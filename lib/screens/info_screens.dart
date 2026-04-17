import 'package:flutter/material.dart';
import 'package:mallu_smart/core/utils/design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InfoScreen extends StatelessWidget {
  final String title;
  final Widget content;

  const InfoScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CuratorDesign.background,
      appBar: AppBar(
        title: Text(title.toUpperCase(), 
          style: CuratorDesign.label(14, weight: FontWeight.w900, color: CuratorDesign.textDark)
            .copyWith(letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CuratorDesign.l),
        physics: const BouncingScrollPhysics(),
        child: content.animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoScreen(
      title: 'About Us',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroImage('https://images.unsplash.com/photo-1593693411515-c202e93db769?q=80&w=2070&auto=format&fit=crop'),
          const SizedBox(height: 24),
          _buildHeading('Our Mission'),
          _buildText('Mallu Smart is dedicated to bridging the gap between traditional Kerala artisans and global enthusiasts. We curate the finest hand-crafted goods, spices, and heritage products directly from the source.'),
          const SizedBox(height: 24),
          _buildHeading('Authenticity First'),
          _buildText('Every product on our marketplace is verified for quality and heritage. We work closely with local self-help groups and individual artisans to ensure you receive a piece of authentic Kerala Culture.'),
        ],
      ),
    );
  }
}

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoScreen(
      title: 'FAQ',
      content: Column(
        children: [
          _buildFaqItem('How do I track my order?', 'You will receive a WhatsApp message and email with a tracking link once your order is shipped.'),
          _buildFaqItem('What is the return policy?', 'We accept returns within 7 days for most unperishable items. Handicrafts are eligible if damaged during transit.'),
          _buildFaqItem('Are the spices organic?', 'Most of our spices are sourced from organic farmers in Idukki and Wayanad, prioritizing natural cultivation.'),
          _buildFaqItem('How can I contact support?', 'Simply use the "Contact Us" option in the drawer to message us directly on WhatsApp.'),
        ],
      ),
    );
  }
}

class ArtisanStoriesScreen extends StatelessWidget {
  const ArtisanStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoScreen(
      title: 'Artisan Stories',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroImage('https://images.unsplash.com/photo-1544652478-6653e09f18a2?q=80&w=2070&auto=format&fit=crop'),
          const SizedBox(height: 24),
          _buildHeading('Master Weaver: Raghavan'),
          _buildText('Meet Raghavan, a third-generation weaver from Kuthampully. With over 40 years of experience, he brings the "Kasavu" tradition to life in every saree.'),
          const SizedBox(height: 24),
          _buildHeading('The Spice Guardians'),
          _buildText('Discover the forest-honey gatherers of Attappady who preserve age-old sustainable methods for harvesting wild honey and forest produce.'),
        ],
      ),
    );
  }
}

class SustainabilityScreen extends StatelessWidget {
  const SustainabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoScreen(
      title: 'Sustainability',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeading('Our Commitment'),
          _buildText('We are committed to a zero-plastic future. Our goal is to shift 100% of our packaging to biodegradable alternatives by the end of 2026.'),
          const SizedBox(height: 24),
          _buildHeading('Community Support'),
          _buildText('70% of our profits go directly back to the artisans and local cooperatives, ensuring fair wages and sustainable growth for rural Kerala villages.'),
        ],
      ),
    );
  }
}

// Helper methods
Widget _buildHeroImage(String url) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Image.network(
      url, 
      height: 200, 
      width: double.infinity, 
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        height: 200,
        color: CuratorDesign.primary.withValues(alpha: 0.1),
        child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
      ),
    ),
  );
}

Widget _buildHeading(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: CuratorDesign.display(18, weight: FontWeight.w800, color: CuratorDesign.primary),
    ),
  );
}

Widget _buildText(String text) {
  return Text(
    text,
    style: CuratorDesign.body(14, color: CuratorDesign.textLight),
  );
}

Widget _buildFaqItem(String question, String answer) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
    ),
    child: ExpansionTile(
      title: Text(question, style: CuratorDesign.label(13, weight: FontWeight.w700)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer, style: CuratorDesign.body(13, color: CuratorDesign.textLight)),
        ),
      ],
    ),
  );
}
