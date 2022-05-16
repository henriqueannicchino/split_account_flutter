import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //controllers to get what the user typed
  final _valueAccountWithoutDrinksController = TextEditingController();
  final _numberOfPeopleController = TextEditingController();
  final _valueAccountDrinksController = TextEditingController();
  final _numberOfPeopleDrinkController = TextEditingController();

  //store user text input into a variable temp remover isso
  String resultTitle = 'Total a pagar';
  String valueAccountWithoutDrinks = '0.00';
  String valueAccountWithDrinks = '0.00';
  double _valueTip = 0;

  _submitForm(BuildContext context) {
    final valueAccountWithoutDrink = double.tryParse(_valueAccountWithoutDrinksController.text) ?? -1.0;
    final numberOfPeople = int.tryParse(_numberOfPeopleController.text) ?? -1;
    final valueAccountDrink = double.tryParse(_valueAccountDrinksController.text) ?? -1.0;
    final numberOfPeopleDrink = int.tryParse(_numberOfPeopleDrinkController.text) ?? -1;
    
    if(valueAccountWithoutDrink > 0 && numberOfPeople <= 0){
      //error missing number of people that ate
      setState(() {
        resultTitle = 'Campo Invalido';
        valueAccountWithoutDrinks = 'error';
        valueAccountWithDrinks = 'Favor verificar o número total de pessoas que comeram.';
      });
    }
    else if(valueAccountWithoutDrink <= 0 && numberOfPeople > 0){
      //error missing number of people that ate
      setState(() {
        resultTitle = 'Campo Invalido';
        valueAccountWithoutDrinks = 'error';
        valueAccountWithDrinks = 'Favor verificar o valor da conta das pessoas que comeram.';
      });
    }
    else if(valueAccountDrink  > 0 && numberOfPeopleDrink <= 0){
      //error missing number of people that drank
      setState(() {
        resultTitle = 'Campo Invalido';
        valueAccountWithoutDrinks = 'error';
        valueAccountWithDrinks = 'Favor verificar o número total de pessoas que beberam.';
      });
    }
    else if(valueAccountDrink  <= 0 && numberOfPeopleDrink > 0){
      //error missing number of people that drank
      setState(() {
        resultTitle = 'Campo Invalido';
        valueAccountWithoutDrinks = 'error';
        valueAccountWithDrinks = 'Favor verificar o valor da conta das pessoas que beberam.';
      });
    }
    else if(valueAccountWithoutDrink > 0 && numberOfPeople > 0 && valueAccountDrink  <= 0 && numberOfPeopleDrink <= 0){
      setState(() {
        resultTitle = 'Total a pagar';
        valueAccountWithoutDrinks = ((valueAccountWithoutDrink+(valueAccountWithoutDrink*(_valueTip/100)))/numberOfPeople).toStringAsFixed(2);
        valueAccountWithDrinks = '0.00';
      });
    }
    else if(valueAccountWithoutDrink <= 0 && valueAccountDrink  > 0 && numberOfPeopleDrink > 0){
      setState(() {
        resultTitle = 'Total a pagar';
        valueAccountWithoutDrinks = '0.00';
        valueAccountWithDrinks = ((valueAccountDrink+(valueAccountDrink*(_valueTip/100)))/numberOfPeopleDrink).toStringAsFixed(2);
      });
    }
    else if(valueAccountWithoutDrink > 0 && numberOfPeople > 0 && valueAccountDrink  > 0 && numberOfPeopleDrink > 0){
      setState(() {
        resultTitle = 'Total a pagar';
        valueAccountWithoutDrinks = ((valueAccountWithoutDrink+(valueAccountWithoutDrink*(_valueTip/100)))/numberOfPeople).toStringAsFixed(2);
        valueAccountWithDrinks = ((valueAccountDrink+(valueAccountDrink*(_valueTip/100)))/numberOfPeopleDrink).toStringAsFixed(2);
      });
    }
    else
      return;

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(resultTitle),
        content: Container(
          height: 60,
          child: Column(
            children: <Widget>[
              Text(
                valueAccountWithoutDrinks=="error" 
                ? valueAccountWithDrinks 
                : valueAccountWithoutDrinks=="0.00" 
                  ? ""
                  : "Pessoas que comeram: R\$${valueAccountWithoutDrinks}"
              ),
              Text(
                valueAccountWithoutDrinks=="error" 
                ? "" 
                : valueAccountWithDrinks=="0.00"
                  ? ""
                  : "Pessoas que beberam: R\$${valueAccountWithDrinks}"
                ),
            ],
          ),
        ),
        actions: [
          FlatButton(
            child: Text(
              'FECHAR', style: TextStyle(color: Colors.cyan)
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    /*bool isLandscape = mediaQuery.orientation == Orientation.landscape;*/

    final PreferredSizeWidget appBar = AppBar(
      title: Text('Rachar Conta'),
      backgroundColor: Colors.cyan
    );

    final availableHeight = mediaQuery.size.height -
      appBar.preferredSize.height - 
      mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                //text input
                TextField(
                  controller: _valueAccountWithoutDrinksController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 20,
                    height: 2
                  ),
                  decoration: InputDecoration(
                    hintText: 'Digite o valor da conta(S/bebida)',
                    prefixIcon: Icon(Icons.dinner_dining_rounded),
                    suffixIcon: IconButton(
                        onPressed: () { 
                          //clear whats currently in the textfield
                          _valueAccountWithoutDrinksController.clear();
                        },
                        icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                TextField(
                  controller: _numberOfPeopleController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 20,
                    height: 2
                  ),
                  decoration: InputDecoration(
                    hintText: 'Digite o número total de pessoas',
                    prefixIcon: Icon(Icons.people_alt_rounded),
                    suffixIcon: IconButton(
                        onPressed: () {
                          //clear whats currently in the textfield
                          _numberOfPeopleController.clear();
                        },
                        icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                TextField(
                  controller: _valueAccountDrinksController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 20,
                    height: 2
                  ),
                  decoration: InputDecoration(
                    hintText: 'Digite o valor da conta das Bebidas',
                    prefixIcon: Icon(Icons.liquor_rounded),
                    suffixIcon: IconButton(
                        onPressed: () {
                          //clear whats currently in the textfield
                          _valueAccountDrinksController.clear();
                        },
                        icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                TextField(
                  controller: _numberOfPeopleDrinkController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(
                    fontSize: 20,
                    height: 2
                  ),
                  decoration: InputDecoration(
                    hintText: 'Digite o número total de pessoas que Beberam',
                    prefixIcon: Icon(Icons.people_alt_rounded),
                    suffixIcon: IconButton(
                        onPressed: () {
                          //clear whats currently in the textfield
                          _numberOfPeopleDrinkController.clear();
                        },
                        icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                Container(
                  width: mediaQuery.size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'Informe a porcentagem da gorgeta:',
                      style: const TextStyle(fontSize: 20)
                    ),
                  ),
                ),
                Slider(
                  value: _valueTip,
                  min: 0,
                  max: 100,
                  divisions: 200,
                  label: _valueTip.toString(),
                  onChanged: (value) {
                    setState(() {
                      _valueTip = double.parse((value).toStringAsFixed(2));
                    });
                  },
                ),
                //button
                MaterialButton(
                  onPressed: () {
                    _submitForm(context);
                  },
                  color: Colors.cyan,
                  child: const Text('Calcular', style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
