import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../../config/theme/app_colors.dart';
import '../../core/services/channels_service.dart';
import '../../core/services/storage_service.dart';
import '../../l10n/app_localizations.dart';

enum _OverlayState {
  checkingAuth,
  notAuthenticated,
  form,
  submitting,
  success,
  error,
}

class ShareOverlayScreen extends StatefulWidget {
  final String youtubeUrl;

  const ShareOverlayScreen({super.key, required this.youtubeUrl});

  @override
  State<ShareOverlayScreen> createState() => _ShareOverlayScreenState();
}

class _ShareOverlayScreenState extends State<ShareOverlayScreen>
    with SingleTickerProviderStateMixin {
  _OverlayState _state = _OverlayState.checkingAuth;
  String _selectedContentType = 'VA_SANS_EDIT';
  String? _errorMessage;
  String? _successChannelName;
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  static const _contentTypes = [
    ('VA_SANS_EDIT', 'VA Sans Edit', AppColors.primary),
    ('VA_AVEC_EDIT', 'VA Avec Edit', AppColors.primary),
    ('VF_SANS_EDIT', 'VF Sans Edit', AppColors.success),
    ('VF_AVEC_EDIT', 'VF Avec Edit', AppColors.success),
    ('VO_SANS_EDIT', 'VO Sans Edit', AppColors.secondary),
    ('VO_AVEC_EDIT', 'VO Avec Edit', AppColors.secondary),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _checkAuth();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _checkAuth() async {
    final isAuth = await StorageService.isAuthenticated();
    if (!mounted) return;
    setState(() {
      _state = isAuth ? _OverlayState.form : _OverlayState.notAuthenticated;
    });
    _animController.forward();
  }

  void _dismiss() {
    _animController.reverse().then((_) {
      ReceiveSharingIntent.instance.reset();
      SystemNavigator.pop();
    });
  }

  Future<void> _submit() async {
    setState(() => _state = _OverlayState.submitting);
    try {
      final channel = await ChannelsService().createSourceChannel(
        youtubeUrl: widget.youtubeUrl,
        contentType: _selectedContentType,
      );
      if (!mounted) return;
      setState(() {
        _state = _OverlayState.success;
        _successChannelName = channel.channelName;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _dismiss();
      });
    } catch (e) {
      if (!mounted) return;
      final errStr = e.toString();
      setState(() {
        _state = _OverlayState.error;
        _errorMessage = errStr.contains('already exists')
            ? null // will use i18n key
            : errStr.replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _dismiss();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: _dismiss,
          child: Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: SlideTransition(
              position: _slideAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {}, // absorb taps on the sheet
                  child: _buildSheet(l10n),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSheet(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: _buildContent(l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    return switch (_state) {
      _OverlayState.checkingAuth => _buildLoading(l10n),
      _OverlayState.notAuthenticated => _buildNotAuthenticated(l10n),
      _OverlayState.form => _buildForm(l10n),
      _OverlayState.submitting => _buildSubmitting(l10n),
      _OverlayState.success => _buildSuccess(l10n),
      _OverlayState.error => _buildError(l10n),
    };
  }

  Widget _buildLoading(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 12),
          Text(l10n.loading, style: GoogleFonts.inter(color: AppColors.gray500)),
        ],
      ),
    );
  }

  Widget _buildNotAuthenticated(AppLocalizations l10n) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Iconsax.lock, color: AppColors.warning, size: 32),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.shareOverlayLoginRequired,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.shareOverlayLoginHint,
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.gray500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _dismiss,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.gray300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.shareOverlayClose,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppColors.gray700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Iconsax.add_circle, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.shareOverlayTitle,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // URL field (read-only)
        Text(
          'URL',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.gray500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.gray50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.gray200),
          ),
          child: Row(
            children: [
              const Icon(Iconsax.link, color: AppColors.gray400, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.youtubeUrl,
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.gray700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Content type
        Text(
          l10n.shareOverlayContentType,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.gray500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _contentTypes.map((type) {
            final (value, label, color) = type;
            final selected = _selectedContentType == value;
            return ChoiceChip(
              label: Text(label),
              selected: selected,
              onSelected: (sel) {
                if (sel) setState(() => _selectedContentType = value);
              },
              selectedColor: color.withValues(alpha: 0.15),
              backgroundColor: AppColors.gray100,
              labelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? color : AppColors.gray600,
              ),
              side: BorderSide(
                color: selected ? color : Colors.transparent,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Submit button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Iconsax.add_circle, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  l10n.shareOverlayAddChannel,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitting(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.shareOverlayAdding,
            style: GoogleFonts.inter(color: AppColors.gray600),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.tick_circle, color: AppColors.success, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.shareOverlaySuccess,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.gray900,
            ),
          ),
          if (_successChannelName != null) ...[
            const SizedBox(height: 6),
            Text(
              _successChannelName!,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildError(AppLocalizations l10n) {
    final isAlreadyExists = _errorMessage == null;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Iconsax.close_circle, color: AppColors.error, size: 32),
        ),
        const SizedBox(height: 16),
        Text(
          isAlreadyExists
              ? l10n.shareOverlayAlreadyExists
              : l10n.commonError,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
          textAlign: TextAlign.center,
        ),
        if (!isAlreadyExists && _errorMessage != null) ...[
          const SizedBox(height: 6),
          Text(
            _errorMessage!,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.gray500),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _dismiss,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: AppColors.gray300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.shareOverlayClose,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray700,
                  ),
                ),
              ),
            ),
            if (!isAlreadyExists) ...[
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => _state = _OverlayState.form),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.commonRetry,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
