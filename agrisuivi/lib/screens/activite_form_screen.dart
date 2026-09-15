import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activite.dart';
import '../providers/activite_provider.dart';

class ActiviteFormScreen extends StatefulWidget {
  final int cultureId;

  const ActiviteFormScreen({super.key, required this.cultureId});

  @override
  State<ActiviteFormScreen> createState() => _ActiviteFormScreenState();
}

class _ActiviteFormScreenState extends State<ActiviteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteCtrl = TextEditingController();
  String _type = TypeActivite.arrosage;
  DateTime _date = DateTime.now();
  DateTime? _dateRappel;
  bool _enEnregistrement = false;

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _choisirDate({required bool pourRappel}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: pourRappel ? (_dateRappel ?? DateTime.now()) : _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        if (pourRappel) {
          _dateRappel = date;
        } else {
          _date = date;
        }
      });
    }
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enEnregistrement = true);

    final activite = Activite(
      cultureId: widget.cultureId,
      type: _type,
      date: _date,
      note: _noteCtrl.text.trim(),
      dateRappel: _dateRappel,
    );

    await context.read<ActiviteProvider>().ajouterActivite(activite);

    if (!mounted) return;
    setState(() => _enEnregistrement = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Activité ajoutée au carnet.')),
    );
    Navigator.of(context).pop();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle activité')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: "Type d'activité", border: OutlineInputBorder()),
                items: TypeActivite.valeurs
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _type = v ?? TypeActivite.arrosage),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _choisirDate(pourRappel: false),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: "Date de l'activité", border: OutlineInputBorder()),
                  child: Text(_formatDate(_date)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Note (optionnel)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _choisirDate(pourRappel: true),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Rappel (optionnel)',
                    border: OutlineInputBorder(),
                    helperText: "Affiché sur le tableau de bord jusqu'à cette date.",
                  ),
                  child: Text(_dateRappel == null ? 'Aucun rappel' : _formatDate(_dateRappel!)),
                ),
              ),
              if (_dateRappel != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => setState(() => _dateRappel = null),
                    child: const Text('Retirer le rappel'),
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _enEnregistrement ? null : _enregistrer,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: _enEnregistrement
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
