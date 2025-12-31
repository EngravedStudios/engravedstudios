import 'package:engravedstudios/core/theme/design_system.dart';
import 'package:engravedstudios/features/press/domain/press_asset.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PressKitPage extends StatelessWidget {
  const PressKitPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final logos = [
      const PressAsset(
        id: 'logo-full-black',
        title: 'Full Logo (Black)',
        description: 'PNG (Transparent)',
        assetUrl: 'assets/images/logo_black.png',
        type: PressAssetType.logo,
      ),
      const PressAsset(
        id: 'logo-full-white',
        title: 'Full Logo (White)',
        description: 'PNG (Transparent)',
        assetUrl: 'assets/images/logo_white.png',
        type: PressAssetType.logo,
      ),
    ];

    final screenshots = [
      const PressAsset(
        id: 'ss-1',
        title: 'Gameplay Action',
        description: '1920x1080 JPG',
        assetUrl: 'assets/images/screenshot_1.jpg',
        type: PressAssetType.screenshot,
      ),
      const PressAsset(
        id: 'ss-2',
        title: 'Main Menu',
        description: '1920x1080 JPG',
        assetUrl: 'assets/images/screenshot_2.jpg',
        type: PressAssetType.screenshot,
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 100, bottom: 48.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRESS KIT',
                  style: GameHUDTextStyles.headlineHeavy.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 32),
                
                // FACT SHEET
                _buildSectionHeader(context, 'FACT SHEET'),
                const SizedBox(height: 16),
                _buildFactRow(context, 'Developer', 'Engraved Studios'),
                _buildFactRow(context, 'Based In', 'Berlin, Germany'),
                _buildFactRow(context, 'Founding Date', '2023'),
                _buildFactRow(context, 'Website', 'engravedstudios.com'),
                _buildFactRow(context, 'Press Contact', 'press@engravedstudios.com'),
                
                const SizedBox(height: 48),

                // DESCRIPTION
                _buildSectionHeader(context, 'DESCRIPTION'),
                const SizedBox(height: 16),
                Text(
                  'Engraved Studios is an indie game development studio focused on creating immersive, atmospheric experiences with a touch of retro charm. We build worlds that players can get lost in.',
                  style: GameHUDTextStyles.body.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 48),

                // LOGOS
                _buildSectionHeader(context, 'LOGOS'),
                const SizedBox(height: 16),
                _buildAssetGrid(context, logos),

                const SizedBox(height: 48),

                // SCREENSHOTS
                _buildSectionHeader(context, 'SCREENSHOTS'),
                const SizedBox(height: 16),
                _buildAssetGrid(context, screenshots),
                
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: GameHUDLayout.borderWidth,
          ),
        ),
      ),
      child: Text(
        title,
        style: GameHUDTextStyles.titleLarge.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildFactRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: GameHUDTextStyles.terminalText.copyWith(
                 fontWeight: FontWeight.bold,
                 color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GameHUDTextStyles.body.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetGrid(BuildContext context, List<PressAsset> assets) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return _PressAssetCard(asset: asset);
      },
    );
  }
}

class _PressAssetCard extends StatelessWidget {
  final PressAsset asset;

  const _PressAssetCard({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: GameHUDLayout.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Colors.black12, // Placeholder bg
              child: Center(
                child: Icon(Icons.image, size: 48, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)), 
                // In real app: Image.asset(asset.assetUrl, fit: BoxFit.contain)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.title,
                  style: GameHUDTextStyles.terminalText.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  asset.description,
                  style: GameHUDTextStyles.codeText.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Logic to download
                    // launchUrl(Uri.parse(asset.assetUrl));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: const RoundedRectangleBorder(), 
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: const Text('DOWNLOAD'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
