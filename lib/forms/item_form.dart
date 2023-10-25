import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entregafinal/models/item.dart';
import 'package:flutter/material.dart';

class ItemFormWidget extends StatelessWidget {
  ItemFormWidget({super.key, this.item});
  
  final Item? item;

  final _formkey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: item?.name);
  late final _valueController = TextEditingController(text: item?.value.toString());

  void _addItem(Item newItem) async{
    await FirebaseFirestore.instance.collection('shopping_list').add(newItem.toMap());
  }

  void _updateItem(Item? item) async{
    await FirebaseFirestore.instance.collection('shopping_list').doc(item!.id).update(item.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: "Item", labelText: "Nome do Item"),
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nome do Item Inválido!";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Valor", labelText: "Valor do Item (R\$)"),
                  controller: _valueController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.startsWith('-')) {
                      return "Valor do Item Inválido!";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      ElevatedButton(
                        child: const Text("Salvar"),
                        onPressed: () {
                          if (_formkey.currentState != null &&
                              _formkey.currentState!.validate()) {
                            double value = double.tryParse(_valueController.text) ?? 0.0;

                            if (item == null){
                              Item newItem = Item(_nameController.text, value);
                              _addItem(newItem);
                            } else{
                              item?.name = _nameController.text;
                              item?.value = value;
                              _updateItem(item);
                            }
                            Navigator.pop(context);
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red 
                        ),
                        child: const Text("Cancelar"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ]
                  )
                )
              ],
            ),
          )
        )
      ]
    );
  }
}
