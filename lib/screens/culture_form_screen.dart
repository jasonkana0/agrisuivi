import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/culture.dart';
import '../providers/culture_provider.dart';

class CultureFormScreen extends StatefulWidget {
  final Culture? cultureAModifier;

  const CultureFormScreen({super.key, this.cultureAModifier});

  @override
  State<CultureFormScreen> createState() => _CultureFormScreenState();
}

class _CultureFormScreenState extends State<CultureFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomCtrl;
  late TextEditingController _varieteCtrl;
  late TextEditingController _parcelleCtrl;
  DateTime _dateSemis = DateTime.now();
  String _statut = 'En cours';
  bool _enEnregistrement = false;

  bool get _modeEdition => widget.cultureAModifier != null;

  @override
  void initState() {
    super.initState();
    final c = widget.cultureAModifier;
    _nomCtrl = TextEditingController(text: c?.nom ?? '');
    _varieteCtrl = TextEditingController(text: c?.variete ?? '');
    _parcelleCtrl = TextEditingController(text: c?.parcelle ?? '');
    if (c != null) {
      _dateSemis = c.dateSemis;
      _statut = c.statut;
    }
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _varieteCtrl.dispose();
    _parcelleCtrl.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateSemis,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _dateSemis = date);
    }
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enEnregistrement = true);
    final provider = context.read<CultureProvider>();

    final culture = Culture(
      id: widget.cultureAModifier?.id,
      nom: _nomCtrl.text.trim(),
      variete: _varieteCtrl.text.trim(),
      parcelle: _parcelleCtrl.text.trim(),
      dateSemis: _dateSemis,
      statut: _statut,
    );

    if (_modeEdition) {
      await provider.modifierCulture(culture);
    } else {
      await provider.ajouterCulture(culture);
    }

    if (!mounted) return;
    setState(() => _enEnregistrement = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_modeEdition ? 'Culture modifiée.' : 'Culture ajoutée.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_modeEdition ? 'Modifier la culture' : 'Nouvelle culture')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: 'Nom de la culture', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Le nom de la culture est obligatoire.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _varieteCtrl,
                decoration: const InputDecoration(labelText: 'Variété', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'La variété est obligatoire.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _parcelleCtrl,
                decoration: const InputDecoration(labelText: 'Parcelle associée', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'La parcelle est obligatoire.' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _choisirDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date de semis', border: OutlineInputBorder()),
                  child: Text('${_dateSemis.day.toString().padLeft(2, '0')}/'
                      '${_dateSemis.month.toString().padLeft(2, '0')}/${_dateSemis.year}'),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _statut,
                decoration: const InputDecoration(labelText: 'Statut', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'En cours', child: Text('En cours')),
                  DropdownMenuItem(value: 'Récoltée', child: Text('Récoltée')),
                ],
                onChanged: (v) => setState(() => _statut = v ?? 'En cours'),
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
