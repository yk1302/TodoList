import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  final bool loading;
  //aese app me jo widget common usse har baar create and decorate color dene ki baajai aesa class create karle jo widget retun kare
  //and iss me variable as parameter declare kare and create constructor so jab ye call ho to vo require argument data leta aaya
  //means button pe text har time different so jab jaha se bhi call ho to vo apna text laye
  const RoundButton(this.title, this.ontap, this.loading, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      onPressed: () {
        ontap();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple.shade400,
      ),
      child: Center(
        child: loading
            ? CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              )
            : Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w900, color: Colors.white),
              ),
      ),
    );
  }
}
