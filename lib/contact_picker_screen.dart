import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'themes.dart';

/// A data class to hold the selected contact's info,
/// matching the [Participant] model in main.dart.
class SelectedContact {
  final String name;
  final String phone;

  SelectedContact({required this.name, required this.phone});
}

class ContactPickerScreen extends StatefulWidget {
  const ContactPickerScreen({super.key});

  @override
  State<ContactPickerScreen> createState() => _ContactPickerScreenState();
}

class _ContactPickerScreenState extends State<ContactPickerScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _loading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _searchController.addListener(_onSearchChanged);
  }

  /// Request permission, then fetch contacts.
  Future<void> _fetchContacts() async {
    final permission = await Permission.contacts.request();
    if (permission.isDenied) {
      setState(() {
        _loading = false;
        _error = 'Permission to access contacts was denied.';
      });
      return;
    }

    try {
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        sorted: true,
      );
      setState(() {
        _contacts = contacts;
        _loading = false;
        _filteredContacts = contacts;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Error loading contacts: $e';
      });
    }
  }

  /// Extract a human-readable name from a Contact.
  String _contactName(Contact c) {
    if (c.displayName.isNotEmpty) return c.displayName;
    final parts = [
      c.name.first,
      c.name.middle,
      c.name.last,
    ];
    final name = parts.where((p) => p.isNotEmpty).join(' ');
    return name.isNotEmpty ? name : 'Unknown';
  }

  /// Extract the first available phone number, preferring mobile.
  String? _contactPhone(Contact c) {
    if (c.phones.isEmpty) return null;

    // Define priority order for phone labels.
    final mobileLabels = <PhoneLabel>{
      PhoneLabel.mobile,
      PhoneLabel.iPhone,
      PhoneLabel.workMobile,
    };

    // 1) Try mobile-type phones first.
    for (final p in c.phones) {
      if (mobileLabels.contains(p.label)) return p.number;
    }

    // 2) Then try primary.
    for (final p in c.phones) {
      if (p.isPrimary) return p.number;
    }

    // 3) Then try main / home.
    for (final p in c.phones) {
      if (p.label == PhoneLabel.main || p.label == PhoneLabel.home) {
        return p.number;
      }
    }

    // 4) Fall back to the first phone.
    return c.phones.first.number;
  }

  /// Filter contacts by search query.
  void _filterContacts(String query) {
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        final name = _contactName(contact).toLowerCase();
        final phone = (_contactPhone(contact) ?? '').toLowerCase();
        return name.contains(query.toLowerCase()) ||
            phone.contains(query.toLowerCase());
      }).toList();
    });
  }

  void _onSearchChanged() {
    _filterContacts(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '📇 Rubrica 🎄',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isAndroid ? 20 : 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _fetchContacts,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _contacts.isEmpty
                  ? const Center(child: Text('No contacts found.'))
                  : Column(
                      children: [
                        // Search bar
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Cerca contatto...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        // Results count
                        if (_searchController.text.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Text(
                              'Trovati ${_filteredContacts.length} contatti',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        // Contact list
                        Expanded(
                          child: ListView.builder(
                            itemCount: _filteredContacts.length,
                            itemBuilder: (context, index) {
                              final contact = _filteredContacts[index];
                              final name = _contactName(contact);
                              final phone = _contactPhone(contact) ?? 'No phone';

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  child: Text(
                                    name.isNotEmpty
                                        ? name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(name),
                                subtitle: Text(phone),
                                onTap: () {
                                  Navigator.pop<SelectedContact>(
                                    context,
                                    SelectedContact(name: name, phone: phone),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
    );
  }
}
