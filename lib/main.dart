import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double saldo = 0;
  double dividaCartao = 0;
  double principalFonteRenda = 0;

  TextEditingController saldoController = TextEditingController();
  TextEditingController dividaCartaoController = TextEditingController();
  TextEditingController principalFonteRendaController = TextEditingController();
  TextEditingController dataPrincipalFonteRendaController = TextEditingController();

  FocusNode saldoFocus = FocusNode();
  FocusNode dividaCartaoFocus = FocusNode();
  FocusNode principalFonteRendaFocus = FocusNode();
  FocusNode dataPrincipalFonteRendaFocus = FocusNode();

  bool editandoSaldo = false;
  bool editandoDividaCartao = false;
  bool editandoPrincipalFonteRenda = false;
  bool editandoDataPrincipalFonteRenda = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gerenciador Financeiro'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildCampo(
                'Saldo Atual: \$${saldo.toStringAsFixed(2)}',
                saldoController,
                saldoFocus,
                'Novo Saldo',
                    () {
                  setState(() {
                    saldo = double.tryParse(saldoController.text) ?? saldo;
                    editandoSaldo = false;
                  });
                },
                editandoSaldo,
                    () {
                  setState(() {
                    editandoSaldo = !editandoSaldo;
                  });
                  _gerenciarFoco(editandoSaldo, saldoFocus);
                },
              ),
              SizedBox(height: 16),
              buildCampo(
                'Dívida do Cartão de Crédito: \$${dividaCartao.toStringAsFixed(2)}',
                dividaCartaoController,
                dividaCartaoFocus,
                'Nova Dívida do Cartão de Crédito',
                    () {
                  setState(() {
                    dividaCartao = double.tryParse(dividaCartaoController.text) ?? dividaCartao;
                    editandoDividaCartao = false;
                  });
                },
                editandoDividaCartao,
                    () {
                  setState(() {
                    editandoDividaCartao = !editandoDividaCartao;
                  });
                  _gerenciarFoco(editandoDividaCartao, dividaCartaoFocus);
                },
              ),
              SizedBox(height: 16),
              buildCampo(
                'Principal Fonte de Renda: \$${principalFonteRenda.toStringAsFixed(2)}',
                principalFonteRendaController,
                principalFonteRendaFocus,
                'Alterar Fonte de Renda',
                    () {
                  setState(() {
                    principalFonteRenda = double.tryParse(principalFonteRendaController.text) ?? principalFonteRenda;
                    editandoPrincipalFonteRenda = false;
                  });
                },
                editandoPrincipalFonteRenda,
                    () {
                  setState(() {
                    editandoPrincipalFonteRenda = !editandoPrincipalFonteRenda;
                  });
                  _gerenciarFoco(editandoPrincipalFonteRenda, principalFonteRendaFocus);
                },
              ),
              SizedBox(height: 16),
              buildCampo(
                'Data da Principal Fonte de Renda: ${_formatarData(dataPrincipalFonteRendaController.text)}',
                dataPrincipalFonteRendaController,
                dataPrincipalFonteRendaFocus,
                'Alterar Data',
                    () {
                  setState(() {
                    editandoDataPrincipalFonteRenda = false;
                  });
                },
                editandoDataPrincipalFonteRenda,
                    () {
                  setState(() {
                    editandoDataPrincipalFonteRenda = !editandoDataPrincipalFonteRenda;
                    dataPrincipalFonteRendaController.text = _formatarData(dataPrincipalFonteRendaController.text);
                  });
                  _gerenciarFoco(editandoDataPrincipalFonteRenda, dataPrincipalFonteRendaFocus);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCampo(String labelText, TextEditingController controller, FocusNode focus, String hintText, VoidCallback onSave, bool editando, VoidCallback onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onToggle,
                child: Text(
                  '${controller.text.isEmpty ? "" : controller.text}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: onToggle,
              child: Text('Modificar'),
            ),
          ],
        ),
        if (editando)
          TextField(
            controller: controller,
            focusNode: focus,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: hintText,
            ),
            enabled: editando,
            onEditingComplete: onSave,
          ),
      ],
    );
  }

  void _gerenciarFoco(bool editando, FocusNode focusNode) {
    if (editando) {
      FocusScope.of(context).requestFocus(focusNode);
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  String _formatarData(String data) {
    if (data.length == 6) {
      return '${data.substring(0, 2)}/${data.substring(2, 4)}/${data.substring(4)}';
    }
    return data;
  }
}
