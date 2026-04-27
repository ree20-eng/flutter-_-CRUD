import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ListUserDataPage());
  }
}

class ListUserDataPage extends StatefulWidget {
  const ListUserDataPage({super.key});

  @override
  State<ListUserDataPage> createState() => _ListUserDataPage();
}

class UserModel {
  int? id;
  String nama;
  int umur;

  UserModel(this.id, {required this.nama, required this.umur});
}

class _ListUserDataPage extends State<ListUserDataPage> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _umurCtrl = TextEditingController();

  List<UserModel> userList = [
    UserModel(1, nama: "satu", umur: 20),
    UserModel(2, nama: "dua", umur: 21),
    UserModel(3, nama: "tiga", umur: 10),
    UserModel(4, nama: "empat", umur: 22),
  ];

  void _form(int? id) {
    if (id != null) {
      var user = userList.firstWhere((data) => data.id == id);
      _nameCtrl.text = user.nama;
      _umurCtrl.text = user.umur.toString();
    } else {
      _nameCtrl.clear();
      _umurCtrl.clear();
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(hintText: "nama"),
            ),
            TextField(
              controller: _umurCtrl,
              decoration: const InputDecoration(hintText: "umur"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () =>
                  _save(id, _nameCtrl.text, int.parse(_umurCtrl.text)),
              child: Text(id == null ? "tambah" : "perbarui"),
            ),
          ],
        ),
      ),
    );
  }

  void _save(int? id, String nama, int umur) {
    if (id != null) {
      var user = userList.firstWhere((data) => data.id == id);
      setState(() {
        user.nama = nama;
        user.umur = umur;
      });
    } else {
      var nextId = userList.length + 1;
      var newUser = UserModel(nextId, nama: nama, umur: umur);

      setState(() {
        userList.add(newUser);
      });
    }

    Navigator.pop(context);
  }

  void _delete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("konfirmasi hapus"),
        content: const Text("apakah anda yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("batal"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                userList.removeWhere((data) => data.id == id);
              });
              Navigator.pop(context);
            },
            child: const Text("hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User List")),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(userList[i].nama),
          subtitle: Text("umur: ${userList[i].umur} tahun"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () => _form(userList[i].id),
                child: const Icon(Icons.edit),
              ),
              TextButton(
                onPressed: () => _delete(userList[i].id!),
                child: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _form(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}