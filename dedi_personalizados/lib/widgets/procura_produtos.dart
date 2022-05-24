import 'package:flutter/material.dart';

class Procura_Produtos extends StatelessWidget {
  const Procura_Produtos({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const TextField(                  
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Procurar produto',
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              );
  }
}