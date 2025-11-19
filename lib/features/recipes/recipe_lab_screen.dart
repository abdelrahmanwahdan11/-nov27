import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controllers/diet_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/community_models.dart';

class RecipeLabScreen extends StatefulWidget {
  const RecipeLabScreen({super.key, required this.controller});

  final DietController controller;

  @override
  State<RecipeLabScreen> createState() => _RecipeLabScreenState();
}

class _RecipeLabScreenState extends State<RecipeLabScreen> {
  double intensity = .6;

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(texts.translate('recipe_lab')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                intensity = (intensity + .2) % 1.0;
              });
            },
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          final locale = Localizations.localeOf(context);
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: PageController(viewportFraction: .8),
                  itemCount: widget.controller.recipeIdeas.length,
                  itemBuilder: (context, index) {
                    final recipe = widget.controller.recipeIdeas[index];
                    final isFav = recipe.favorite;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        image: DecorationImage(
                          image: NetworkImage(recipe.image),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.25),
                            blurRadius: 24,
                            offset: const Offset(0, 16),
                          )
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(.7 - intensity / 3),
                              Colors.black.withOpacity(.2),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.pinkAccent,
                                ),
                                onPressed: () =>
                                    widget.controller.toggleRecipeFavorite(recipe.id),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              recipe.localizedTitle(locale),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              recipe.localizedDescription(locale),
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 12),
                            Text('${recipe.calories} kcal',
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: .2)
                        .scale(begin: .95);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(texts.translate('flavor_intensity')),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Slider(
                            value: intensity,
                            onChanged: (value) {
                              setState(() => intensity = value);
                              for (final recipe in widget.controller.recipeIdeas) {
                                widget.controller.updateRecipeSparkle(recipe.id, value);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(texts.translate('recipe_intro')),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: texts.translate('favorite_recipes_cta'),
                      onPressed: () {
                        final favs = widget.controller.recipeIdeas
                            .where((element) => element.favorite)
                            .length;
                        final snack = SnackBar(
                          content: Text(
                            '${texts.translate('favorites_updated')} ($favs)',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      },
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
