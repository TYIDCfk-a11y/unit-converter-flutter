import 'package:flutter/material.dart';

 

void main() => runApp(const UnitConverterApp());

 

class UnitConverterApp extends StatelessWidget {

  const UnitConverterApp({super.key});

 

  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Unit Converter App',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),

      home: const ConverterHome(),

    );

  }

}

 

class ConverterHome extends StatefulWidget {

  const ConverterHome({super.key});

 

  @override

  _ConverterHomeState createState() => _ConverterHomeState();

}

 

class _ConverterHomeState extends State<ConverterHome>

    with SingleTickerProviderStateMixin {

  late TabController _tabController;

 

  final List<String> tabs = const [

    "Length",

    "Area",

    "Time",

    "Data",

    "Weight",

    "Temperature"

  ];

 

  final List<Color> tabColors = const [

    Colors.blueAccent,

    Colors.green,

    Colors.orange,

    Colors.teal,

    Colors.purple,

    Colors.redAccent

  ];

 

  final List<IconData> tabIcons = const [

    Icons.straighten, // Length

    Icons.crop_square, // Area

    Icons.access_time, // Time

    Icons.storage, // Data

    Icons.fitness_center, // Weight

    Icons.thermostat // Temperature

  ];

 

  @override

  void initState() {

    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);

  }

 

  @override

  void dispose() {

    _tabController.dispose();

    super.dispose();

  }

 

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(

        children: [

          AnimatedContainer(

            duration: const Duration(milliseconds: 500),

            decoration: BoxDecoration(

              gradient: LinearGradient(

                colors: [

                  tabColors[_tabController.index]

                      .withAlpha((255 * 0.9).round()),

                  Colors.white

                ],

                begin: Alignment.topCenter,

                end: Alignment.bottomCenter,

              ),

            ),

          ),

          Column(

            children: [

              const SizedBox(height: 40),

              const Text(

                "Unit Converter App",

                style: TextStyle(

                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                  color: Colors.white,

                  shadows: [

                    Shadow(

                      blurRadius: 6,

                      color: Colors.black38,

                      offset: Offset(2, 2),

                    ),

                  ],

                ),

              ),

              const SizedBox(height: 10),

              TabBar(

                controller: _tabController,

                indicatorColor: Colors.white,

                indicatorWeight: 3,

                isScrollable: true,

                tabs: List.generate(

                  tabs.length,

                  (int i) => Tab(

                    icon: Icon(tabIcons[i], color: Colors.white),

                    text: tabs[i],

                  ),

                ),

                onTap: (_) => setState(() {}),

              ),

              Expanded(

                child: TabBarView(

                  controller: _tabController,

                  children: <Widget>[

                    // Length

                    ConverterTab(

                      title: "Length Converter",

                      units: const {

                        "Meters": 1,

                        "Kilometers": 0.001,

                        "Centimeters": 100,

                        "Miles": 0.000621371

                      },

                      color: tabColors[0],

                    ),

                    // Area

                    ConverterTab(

                      title: "Area Converter",

                      units: const {

                        "Square Meters": 1,

                        "Square Kilometers": 0.000001,

                        "Square Miles": 3.861e-7,

                        "Acres": 0.000247105

                      },

                      color: tabColors[1],

                    ),

                    // Time

                    ConverterTab(

                      title: "Time Converter",

                      units: const {

                        "Seconds": 1,

                        "Minutes": 1 / 60,

                        "Hours": 1 / 3600,

                        "Days": 1 / 86400

                      },

                      color: tabColors[2],

                    ),

                    // Data

                    ConverterTab(

                      title: "Data Converter",

                      units: const {

                        "Bytes": 1,

                        "Kilobytes": 1 / 1024,

                        "Megabytes": 1 / (1024 * 1024),

                        "Gigabytes": 1 / (1024 * 1024 * 1024)

                      },

                      color: tabColors[3],

                    ),

                    // Weight

                    ConverterTab(

                      title: "Weight Converter",

                      units: const {

                        "Kilograms": 1,

                        "Grams": 1000,

                        "Pounds": 2.20462,

                        "Ounces": 35.274

                      },

                      color: tabColors[4],

                    ),

                    // Temperature

                    ConverterTab(

                      title: "Temperature Converter",

                      isTemperature: true,

                      color: tabColors[5],

                    ),

                  ],

                ),

              )

            ],

          ),

        ],

      ),

    );

  }

}

 

class ConverterTab extends StatefulWidget {

  final String title;

  final Map<String, double>? units;

  final bool isTemperature;

  final Color color;

 

  const ConverterTab({

    super.key,

    required this.title,

    this.units,

    this.isTemperature = false,

    required this.color,

  });

 

  @override

  _ConverterTabState createState() => _ConverterTabState();

}

 

class _ConverterTabState extends State<ConverterTab>

    with SingleTickerProviderStateMixin {

  String fromUnit = "";

  String toUnit = "";

  double inputValue = 0;

  double resultValue = 0;

  late AnimationController _controller;

  late Animation<Offset> _slideAnimation;

 

  @override

  void initState() {

    super.initState();

    if (!widget.isTemperature && widget.units != null) {

      fromUnit = widget.units!.keys.first;

      toUnit = widget.units!.keys.elementAt(1);

    } else if (widget.isTemperature) {

      final List<String> tempUnits = const ["Celsius", "Fahrenheit", "Kelvin"];

      fromUnit = tempUnits.first;

      toUnit = tempUnits.elementAt(1);

    }

    _controller =

        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _slideAnimation =

        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(

            CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  }

 

  @override

  void dispose() {

    _controller.dispose();

    super.dispose();

  }

 

  void convert() {

    setState(() {

      if (inputValue == 0) {

        resultValue = 0;

        _controller.forward(from: 0);

        return;

      }

      if (widget.isTemperature) {

       

        final Map<String, double> _ = const {

          "Celsius": 1.0,

          "Fahrenheit": 0.0,

          "Kelvin": 273.15,

        };

 

       

        double valueInCelsius;

 

       

        if (fromUnit == "Celsius") {

          valueInCelsius = inputValue;

        } else if (fromUnit == "Fahrenheit") {

          valueInCelsius = (inputValue - 32) * 5 / 9;

        } else if (fromUnit == "Kelvin") {

          valueInCelsius = inputValue - 273.15;

        } else {

          valueInCelsius = inputValue;

        }

 

      

        if (toUnit == "Celsius") {

          resultValue = valueInCelsius;

        } else if (toUnit == "Fahrenheit") {

          resultValue = (valueInCelsius * 9 / 5) + 32;

        } else if (toUnit == "Kelvin") {

          resultValue = valueInCelsius + 273.15;

        } else {

          resultValue = valueInCelsius;

        }

 

      } else {

        double baseValue = inputValue / widget.units![fromUnit]!;

        resultValue = baseValue * widget.units![toUnit]!;

      }

      _controller.forward(from: 0);

    });

  }

 

  @override

  Widget build(BuildContext context) {

    return Center(

      child: SlideTransition(

        position: _slideAnimation,

        child: Container(

          padding: const EdgeInsets.all(14),

          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius: BorderRadius.circular(14),

            boxShadow: [

              BoxShadow(

                blurRadius: 10,

                color: widget.color.withAlpha((255 * 0.3).round()), // Fix applied here

                offset: const Offset(0, 5),

              )

            ],

          ),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                widget.title,

                style: TextStyle(

                  fontSize: 18,

                  fontWeight: FontWeight.bold,

                  color: widget.color,

                ),

              ),

              const SizedBox(height: 12),

              CustomInputField(

                label: "Enter value",

                onChanged: (String val) {

                  setState(() {

                    inputValue = double.tryParse(val) ?? 0;

                  });

                },

              ),

              const SizedBox(height: 12),

              Row(

                children: [

                  Expanded(

                    child: widget.isTemperature

                        ? TemperatureDropdown(

                            selectedUnit: fromUnit,

                            onChanged: (String? val) {

                              setState(() {

                                fromUnit = val!;

                              });

                            },

                          )

                        : UnitDropdown(

                            units: widget.units!.keys.toList(),

                            selectedUnit: fromUnit,

                            onChanged: (String? val) {

                              setState(() {

                                fromUnit = val!;

                              });

                            },

                          ),

                  ),

                  const SizedBox(width: 8),

                  Icon(Icons.swap_horiz, size: 28, color: widget.color),

                  const SizedBox(width: 8),

                  Expanded(

                    child: widget.isTemperature

                        ? TemperatureDropdown(

                            selectedUnit: toUnit,

                            onChanged: (String? val) {

                              setState(() {

                                toUnit = val!;

                              });

                            },

                          )

                        : UnitDropdown(

                            units: widget.units!.keys.toList(),

                            selectedUnit: toUnit,

                            onChanged: (String? val) {

                              setState(() {

                                toUnit = val!;

                              });

                            },

                          ),

                  ),

                ],

              ),

              const SizedBox(height: 16),

              ElevatedButton(

                style: ElevatedButton.styleFrom(

                  backgroundColor: widget.color,

                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(10),

                  ),

                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                ),

                onPressed: convert,

                child: const Text("Convert",

                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),

              ),

              const SizedBox(height: 14),

              AnimatedSwitcher(

                duration: const Duration(milliseconds: 400),

                child: Text(

                  "Result: ${resultValue.toStringAsFixed(4)}",

                  key: ValueKey<double>(resultValue),

                  style: TextStyle(

                    fontSize: 20,

                    fontWeight: FontWeight.bold,

                    color: widget.color,

                  ),

                ),

              )

