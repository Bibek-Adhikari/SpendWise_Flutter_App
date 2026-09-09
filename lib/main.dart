import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const SpendWiseApp());

class Expense {
  final String title;
  final String category;
  final String note;
  final double amount;
  final DateTime date;

  Expense({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    this.note = '',
  });
}

class SpendWiseApp extends StatefulWidget {
  const SpendWiseApp({super.key});

  @override
  State<SpendWiseApp> createState() => _SpendWiseAppState();
}

class _SpendWiseAppState extends State<SpendWiseApp> {
  final List<Expense> expenses = [
    Expense(title: 'Lunch', category: 'Food', amount: 20, date: DateTime.now().subtract(const Duration(days: 1))),
    Expense(title: 'Transport', category: 'Transport', amount: 15, date: DateTime.now().subtract(const Duration(days: 2))),
    Expense(title: 'Shopping', category: 'Shopping', amount: 45, date: DateTime.now().subtract(const Duration(days: 3))),
  ];

  double monthlyBudget = 1000;
  bool loggedIn = false;

  double get totalExpenses => expenses.fold(0, (sum, expense) => sum + expense.amount);
  double get income => 3000;
  double get balance => income - totalExpenses;

  void addExpense(Expense expense) {
    setState(() => expenses.insert(0, expense));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpendWise',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF20B486)),
        scaffoldBackgroundColor: const Color(0xFFF7FAF9),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF20B486), width: 2),
          ),
        ),
      ),
      home: loggedIn
          ? HomeShell(app: this)
          : LoginPage(onLogin: () => setState(() => loggedIn = true)),
    );
  }
}

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController(text: 'demo@spendwise.app');
  final password = TextEditingController(text: 'password');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const CircleAvatar(
                    radius: 34,
                    backgroundColor: Color(0xFFE4F8F1),
                    child: Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF20B486), size: 34),
                  ),
                  const SizedBox(height: 20),
                  const Text('Welcome Back', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Login to manage your expenses', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 30),
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email', hintText: 'Enter your email'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password', hintText: 'Enter your password'),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: () {}, child: const Text('Forgot Password?')),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: widget.onLogin,
                    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 12),
                  const Text('Don’t have an account? Sign Up', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  final _SpendWiseAppState app;

  const HomeShell({super.key, required this.app});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  List<Widget> get pages => [
        Dashboard(app: widget.app, onAdd: () => setState(() => index = 1)),
        AddExpensePage(app: widget.app, onSaved: () => setState(() => index = 0)),
        TransactionsPage(app: widget.app),
        BudgetPage(app: widget.app),
        ReportPage(app: widget.app),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Add'),
          NavigationDestination(icon: Icon(Icons.swap_horiz), selectedIcon: Icon(Icons.swap_horiz), label: 'Transactions'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'Budget'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Report'),
        ],
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  final _SpendWiseAppState app;
  final VoidCallback onAdd;

  const Dashboard({super.key, required this.app, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good morning', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Manage your money wisely', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const CircleAvatar(
              backgroundColor: Color(0xFFE4F8F1),
              child: Icon(Icons.person, color: Color(0xFF20B486)),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Card(
          color: const Color(0xFF20B486),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Balance', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 4),
                Text('\$${app.balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                Row(children: [_stat('Income', app.income), _stat('Expenses', app.totalExpenses)]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('Add Expense'),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TransactionsPage(app: app))),
              child: const Text('View All'),
            ),
          ],
        ),
        ...app.expenses.take(5).map(_txTile),
      ],
    );
  }

  Widget _stat(String label, double value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text('\$${value.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
        ],
      ),
    );
  }

  Widget _txTile(Expense expense) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAF7F2),
          child: Icon(_icon(expense.category), color: const Color(0xFF20B486)),
        ),
        title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${expense.category} • ${expense.date.day}/${expense.date.month}/${expense.date.year}'),
        trailing: Text('-\$${expense.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class AddExpensePage extends StatefulWidget {
  final _SpendWiseAppState app;
  final VoidCallback onSaved;

  const AddExpensePage({super.key, required this.app, required this.onSaved});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final title = TextEditingController();
  final amount = TextEditingController();
  final note = TextEditingController();
  String category = 'Food';
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Add Expense', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Record a new transaction', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 22),
        TextField(
          controller: amount,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$ '),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: title,
          decoration: const InputDecoration(labelText: 'Expense Title', hintText: 'e.g. Lunch'),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          value: category,
          decoration: const InputDecoration(labelText: 'Category'),
          items: ['Food', 'Transport', 'Shopping', 'Bills', 'Other']
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (value) => setState(() => category = value ?? category),
        ),
        const SizedBox(height: 14),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Date'),
          subtitle: Text('${date.day}/${date.month}/${date.year}'),
          trailing: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );
              if (selected != null) setState(() => date = selected);
            },
          ),
        ),
        TextField(
          controller: note,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Notes', hintText: 'Add a short note'),
        ),
        const SizedBox(height: 22),
        FilledButton(
          onPressed: save,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          child: const Text('Save Expense'),
        ),
      ],
    );
  }

  void save() {
    final value = double.tryParse(amount.text.trim());
    if (title.text.trim().isEmpty || value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid title and amount.')));
      return;
    }

    widget.app.addExpense(
      Expense(
        title: title.text.trim(),
        category: category,
        amount: value,
        date: date,
        note: note.text.trim(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Expense saved successfully.')));
    widget.onSaved();
  }
}

class TransactionsPage extends StatelessWidget {
  final _SpendWiseAppState app;

  const TransactionsPage({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Transactions', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Review your income and expenses', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),
        const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search transactions')),
        const SizedBox(height: 14),
        ...app.expenses.map(
          (expense) => Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(_icon(expense.category))),
              title: Text(expense.title),
              subtitle: Text('${expense.category} • ${expense.date.day}/${expense.date.month}/${expense.date.year}'),
              trailing: Text('-\$${expense.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}

class BudgetPage extends StatefulWidget {
  final _SpendWiseAppState app;

  const BudgetPage({super.key, required this.app});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    final percentage = (widget.app.totalExpenses / widget.app.monthlyBudget).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('My Budget', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Plan and control your monthly spending', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 18),
        Card(
          color: const Color(0xFF20B486),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Monthly Budget', style: TextStyle(color: Colors.white70)),
                Text('\$${widget.app.monthlyBudget.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: percentage, backgroundColor: Colors.white24, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  'Spent \$${widget.app.totalExpenses.toStringAsFixed(0)} • Remaining \$${math.max(0, widget.app.monthlyBudget - widget.app.totalExpenses).toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Category Budgets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            OutlinedButton(onPressed: editBudget, child: const Text('Edit')),
          ],
        ),
        ...['Food', 'Transport', 'Shopping', 'Bills'].map((categoryName) {
          final spent = widget.app.expenses
              .where((expense) => expense.category == categoryName)
              .fold(0.0, (sum, expense) => sum + expense.amount);
          final limits = {'Food': 300.0, 'Transport': 200.0, 'Shopping': 200.0, 'Bills': 150.0};
          final limit = limits[categoryName]!;
          final used = (spent / limit).clamp(0.0, 1.0);

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(categoryName, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('\$${spent.toStringAsFixed(0)} / \$${limit.toStringAsFixed(0)}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: used),
                  const SizedBox(height: 6),
                  Text('${(spent / limit * 100).clamp(0, 100).toStringAsFixed(0)}% used', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void editBudget() {
    final controller = TextEditingController(text: widget.app.monthlyBudget.toStringAsFixed(0));

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Monthly budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: '\$ '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(controller.text.trim());
              if (value != null && value > 0) {
                setState(() => widget.app.monthlyBudget = value);
              }
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class ReportPage extends StatelessWidget {
  final _SpendWiseAppState app;

  const ReportPage({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    final categories = ['Food', 'Transport', 'Shopping', 'Bills'];
    final values = categories
        .map((category) => app.expenses.where((expense) => expense.category == category).fold(0.0, (sum, expense) => sum + expense.amount))
        .toList();
    final maxValue = values.fold(1.0, math.max);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Spending Report', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('Understand where your money is going', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 18),
        Row(children: [_metric('Income', app.income), _metric('Expenses', app.totalExpenses), _metric('Saved', app.balance)]),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Spending Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),
                SizedBox(
                  height: 190,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int i = 0; i < categories.length; i++)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 38,
                              height: maxValue == 0 ? 0 : 120 * (values[i] / maxValue),
                              decoration: BoxDecoration(
                                color: const Color(0xFF20B486),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(categories[i], style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text('Expense Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...List.generate(
          categories.length,
          (index) => ListTile(
            leading: CircleAvatar(child: Icon(_icon(categories[index]))),
            title: Text(categories[index]),
            trailing: Text('\$${values[index].toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _metric(String label, double value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text('\$${value.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _icon(String category) {
  switch (category) {
    case 'Food':
      return Icons.restaurant;
    case 'Transport':
      return Icons.directions_bus;
    case 'Shopping':
      return Icons.shopping_bag;
    case 'Bills':
      return Icons.receipt_long;
    default:
      return Icons.category;
  }
}
