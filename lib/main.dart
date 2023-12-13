import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double saldo = 0;
  double dividaCartao = 0;
  double principalFonteRenda = 0;
  double resultadoSubtracao = 0;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador Financeiro'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    principalFonteRenda =
                        double.tryParse(principalFonteRendaController.text) ?? principalFonteRenda;
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
                    dataPrincipalFonteRendaController.text =
                        _formatarData(dataPrincipalFonteRendaController.text);
                  });
                  _gerenciarFoco(editandoDataPrincipalFonteRenda, dataPrincipalFonteRendaFocus);
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    resultadoSubtracao = saldo - dividaCartao;
                  });
                },
                child: Text('Subtrair Dívida do Cartão'),
              ),
              SizedBox(height: 16),
              Text(
                'O que você realmente tem: \$${resultadoSubtracao.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AtivosScreen()),
                  );
                },
                child: Text('Ver Ativos e outras dívidas'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCampo(String labelText, TextEditingController controller, FocusNode focus, String hintText,
      VoidCallback onSave, bool editando, VoidCallback onToggle) {
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




// mudança de páginas, separar para ficar mais fácil de organizar

















//representa a tela de ativos e dívidas
class AtivosScreen extends StatefulWidget {
  @override
  _AtivosScreenState createState() => _AtivosScreenState();
}

// classe para manter os estados dos itens finaceiros
class _AtivosScreenState extends State<AtivosScreen> {
  // fontes de renda ou dívidas são listas que armazenam itens financeiros
  List<ItemFinanceiro> fontesDeRenda = [];
  List<ItemFinanceiro> dividas = [];

  //são controladores de textos associados aos campos do formulário de edição
  TextEditingController nomeController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ativos e Dívidas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildColumn("Fontes de Renda", fontesDeRenda),
            _buildColumn("Dívidas", dividas),
          ],
        ),
      ),
    );
  }

  //função privada que cria uma coluna para exibir fontes de renda ou dívidas.
  Widget _buildColumn(String title, List<ItemFinanceiro> items) { // construir coluna
    return Expanded( // para garantir que o conteúdo se expanda conforme o necessário
      child: Column( // organiza os elementos verticalmente e esses elementos são listados em children
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( // exibe o título da coluna com um estilo específico (style)
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton( // quando clica no botão ele chama o _showAddDialog
            onPressed: () { //função chamada quando o botão é presisonado
              _showAddDialog(title, items);
            },
            child: Text('Adicionar $title'), //conteúdo do botão
          ),
          SizedBox(height: 8), //adicona um espço de 8 pixels entre o botão e a lista
          Column( //outra coluna com a lista dos itens finaceiros
            children: items.map((item) => _buildItemCard(item)).toList(),//coloca cada item finaceiro
            //em uma lista
          ),
          SizedBox(height: 16), //espaço vertical de 16 pixels
        ],
      ),
    );
  }

  //cria um Card(cartão) que tem um ListTile
  Widget _buildItemCard(ItemFinanceiro item) {
    return Card( //Container com os sefuintes detalhes
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile( //estruturas para exibir informações em uma única linha
        title: Text(item.nome),
        subtitle: Text('Valor: \$${item.valor.toStringAsFixed(2)}\nDescrição: ${item.descricao}'),
      ),
    );
  }

  //exibe um diálogo modal para para adicionar um novo item finaceiro
  Future<void> _showAddDialog(String title, List<ItemFinanceiro> items) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog( //caixa de diálogo
          title: Text('Adicionar $title'), //Renda ou Dívidas
          content: SingleChildScrollView( //caso o conteúdo for muito grande vai ter a rolagem
            child: Column(
              children: <Widget>[
                //aqui são as três informações: nome, Valor e Descrição
                TextField(
                  controller: nomeController,
                  decoration: InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: valorController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Valor'),
                ),
                TextField(
                  controller: descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); //fecha o diálogo sme fazer nenhuma alteração
              },
              child: Text('Cancelar'), //define o conteúdo do botão
            ),
            TextButton(
              onPressed: () {
                if (nomeController.text.isNotEmpty && valorController.text.isNotEmpty) {
                  //se n forem vazios
                  ItemFinanceiro novoItem = ItemFinanceiro(
                    nome: nomeController.text,
                    valor: double.parse(valorController.text),
                    descricao: descricaoController.text,
                  );

                  setState(() {
                    items.add(novoItem);
                  });

                  // Limpar os campos após adicionar
                  nomeController.clear();
                  valorController.clear();
                  descricaoController.clear();

                  Navigator.pop(context); //fecha a tela atual e volta para a anterior
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }
}

class ItemFinanceiro {
  final String nome; //não pode ser laterado após ser definido
  final double valor;
  final String descricao;

  ItemFinanceiro({ //valores obrigatorios ao criar o item
    required this.nome,
    required this.valor,
    required this.descricao,
  });
}
