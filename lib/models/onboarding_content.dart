class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Discover Kerala",
    image: "assets/images/onboarding_discover.png",
    desc: "Find authentic products from local artisans and homemade brands across Kerala.",
  ),
  OnboardingContents(
    title: "Easy Checkout",
    image: "assets/images/onboarding_checkout.png",
    desc: "Secure and seamless payment experience for all your traditional finds.",
  ),
  OnboardingContents(
    title: "Fast Delivery",
    image: "assets/images/onboarding_delivery.png",
    desc: "Quick and reliable delivery to your doorstep, anywhere in the state.",
  ),
];
