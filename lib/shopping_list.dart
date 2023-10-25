import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entregafinal/forms/item_form.dart';
import 'package:entregafinal/models/item.dart';
import 'package:flutter/material.dart';

class ShoppingListScreenState extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreenState> {
  final Set<Item> _checkedItems = {};

  void _removeCheckedItems() {
    setState(() {
      _checkedItems.forEach((item) async {
        await FirebaseFirestore.instance.collection('shopping_list').doc(item.id).delete();
      });
      _checkedItems.clear();
    });
  }

  void _toggleItem(Item item) {
    setState(() {
      if (_checkedItems.contains(item)) {
        _checkedItems.remove(item);
      } else {
        _checkedItems.add(item);
      }
    });
  }

  Widget _buildList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('shopping_list').snapshots(), 
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

            Item item = Item.fromMap(data, document.id);
            return ListTile(
              leading: Checkbox(
                value: _checkedItems.contains(item),
                onChanged: (value) {
                  _toggleItem(item);
                },
              ),
              title: Text(item.name),
              subtitle: Text("R\$ ${item.value.toStringAsFixed(2)}"),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Editar Item'),
                        content: ItemFormWidget(item: item)
                      );
                    }
                  );
                },
              )
            );
          }).toList(),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
      ),
      body: _buildList(context), 
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Adicionar Item'),
                    content: ItemFormWidget()
                  );
                },
              );
            },
            tooltip: 'Adicionar Item',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _removeCheckedItems();
            },
            tooltip: 'Remover Itens Marcados',
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}