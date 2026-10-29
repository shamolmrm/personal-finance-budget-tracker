import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/goal_model.dart';
import '../providers/goal_provider.dart';
import '../widgets/goal_card.dart';
import 'create_goal_screen.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  late final ConfettiController _confettiController;
  String _aiMessage = '';

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _showAddMoneySheet(BuildContext context, GoalModel goal) async {
    final amountController = TextEditingController();
    await showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Add money to goal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Save'))
        ]),
      ),
    );
  }

  Future<void> _generateGoalSuggestion() async {
    final suggestion = await ref.read(aiGoalSuggestionProvider.future);
    setState(() => _aiMessage = suggestion);
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: goals.when(
            data: (items) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Set your financial milestones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (_aiMessage.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
                  child: Text(_aiMessage, style: const TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 12),
              ],
              Row(children: [
                Expanded(child: ElevatedButton.icon(onPressed: _generateGoalSuggestion, icon: const Icon(Icons.smart_toy), label: const Text('AI Suggest'))),
                const SizedBox(width: 12),
                ElevatedButton.icon(onPressed: () async {
                  final newGoal = await Navigator.of(context).push<GoalModel>(MaterialPageRoute(builder: (_) => const CreateGoalScreen()));
                  if (newGoal != null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Goal created successfully')));
                    if (newGoal.progress >= 1.0) _confettiController.play();
                  }
                }, icon: const Icon(Icons.add), label: const Text('Add Goal'))
              ]),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final goal = items[index];
                    if (goal.progress >= 1.0) {
                      WidgetsBinding.instance.addPostFrameCallback((_) => _confettiController.play());
                    }
                    return GoalCard(goal: goal, onAddMoney: () => _showAddMoneySheet(context, goal));
                  },
                ),
              )
            ]),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Unable to load goals: $error')),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [Colors.green, Colors.blue, Colors.pink, Colors.yellow],
          ),
        )
      ]),
    );
  }
}
