import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/api/api_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MembersListPage extends ConsumerStatefulWidget {
  const MembersListPage({super.key});

  @override
  ConsumerState createState() => _MembersListPageState();
}

class _MembersListPageState extends ConsumerState<MembersListPage> {
  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.teamMemberList),
      ),
      body: members.isEmpty
          ?
          // const Center(
          //     child: CupertinoActivityIndicator(
          //     radius: 40,
          //     color: Colors.deepPurple,
          //   ))
          const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  title: Text(
                    member.name,
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(member.email,
                      style: const TextStyle(color: Colors.grey)),
                );
              },
            ),
    );
  }
}
