import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeamMembersField extends StatefulWidget {
  final List<String> teamMembers;
  final Function(String) onMemberAdded;
  final Function(String) onMemberRemoved;

  const TeamMembersField({
    Key? key,
    required this.teamMembers,
    required this.onMemberAdded,
    required this.onMemberRemoved,
  }) : super(key: key);

  @override
  _TeamMembersFieldState createState() => _TeamMembersFieldState();
}

class _TeamMembersFieldState extends State<TeamMembersField> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _textEditingController,
          onChanged: (value) {
            widget.onMemberAdded(value);
          },
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.teamMembers,
            suffixIcon: IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                _textEditingController.clear();
              },
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: widget.teamMembers.map((member) {
              return FilterChip(
                label: Text(member),
                onSelected: (bool selected) {
                  if (!selected) {
                    widget.onMemberRemoved(member);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
