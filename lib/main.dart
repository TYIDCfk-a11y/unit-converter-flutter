import 'package:flutter/material.dart';

void main() => runApp(const UnitConverterApp());

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ConverterHome(),
    );
  }
}

class ConverterHome extends StatefulWidget {
  const ConverterHome({super.key});

  @override
  State<ConverterHome> createState() => _ConverterHomeState();
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
    Icons.straighten,
    Icons.crop_square,
    Icons.access_time,
    Icons.storage,
    Icons.fitness_center,
    Icons.thermostat,
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
                  Colors.white,
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
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.white,
                onTap: (_) => setState(() {}),
                tabs: List.generate(
                  tabs.length,
                  (i) => Tab(
                    icon: Icon(tabIcons[i], color: Colors.white),
                    text: tabs[i],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ConverterTab(
                      title: "Length Converter",
                      units: const {
                        "Meters": 1,
                        "Kilometers": 0.001,
                        "Centimeters": 100,
                        "Miles": 0.000621371,
                      },
                      color: tabColors[0],
                    ),
                    ConverterTab(
                      title: "Area Converter",
                      units: const {
                        "Square Meters": 1,
                        "Square Kilometers": 0.000001,
                        "Square Miles": 3.861e-7,
                        "Acres": 0.000247105,
                      },
                      color: tabColors[1],
                    ),
                    ConverterTab(
                      title: "Time Converter",
                      units: const {
                        "Seconds": 1,
                        "Minutes": 1 / 60,
                        "Hours": 1 / 3600,
                        "Days": 1 / 86400,
                      },
                      color: tabColors[2],
                    ),
                    ConverterTab(
                      title: "Data Converter",
                      units: const {
                        "Bytes": 1,
                        "Kilobytes": 1 / 1024,
                        "Megabytes": 1 / (1024 * 1024),
                        "Gigabytes": 1 / (1024 * 1024 * 1024),
                      },
                      color: tabColors[3],
                    ),
                    ConverterTab(
                      title: "Weight Converter",
                      units: const {
                        "Kilograms": 1,
                        "Grams": 1000,
                        "Pounds": 2.20462,
                        "Ounces": 35.274,
                      },
                      color: tabColors[4],
                    ),
                    ConverterTab(
                      title: "Temperature Converter",
                      isTemperature: true,
                      color: tabColors[5],
                    ),
                  ],
                ),
              ),
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
  State<ConverterTab> createState() => _ConverterTabState();
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

    if (widget.isTemperature) {
      fromUnit = "Celsius";
      toUnit = "Fahrenheit";
    } else {
      fromUnit = widget.units!.keys.first;
      toUnit = widget.units!.keys.elementAt(1);
    }

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void convert() {
    setState(() {
      if (widget.isTemperature) {
        double celsius;
        if (fromUnit == "Fahrenheit") {
          celsius = (inputValue - 32) * 5 / 9;
        } else if (fromUnit == "Kelvin") {
          celsius = inputValue - 273.15;
        } else {
          celsius = inputValue;
        }

        if (toUnit == "Fahrenheit") {
          resultValue = (celsius * 9 / 5) + 32;
        } else if (toUnit == "Kelvin") {
          resultValue = celsius + 273.15;
        } else {
          resultValue = celsius;
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
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: widget.color.withAlpha((255 * 0.3).round()),
                offset: const Offset(0, 5),
              ),
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
                onChanged: (val) =>
                    inputValue = double.tryParse(val) ?? 0,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: widget.isTemperature
                        ? TemperatureDropdown(
                            value: fromUnit,
                            onChanged: (v) => setState(() => fromUnit = v!),
                          )
                        : UnitDropdown(
                            units: widget.units!.keys.toList(),
                            value: fromUnit,
                            onChanged: (v) => setState(() => fromUnit = v!),
                          ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.swap_horiz, color: widget.color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: widget.isTemperature
                        ? TemperatureDropdown(
                            value: toUnit,
                            onChanged: (v) => setState(() => toUnit = v!),
                          )
                        : UnitDropdown(
                            units: widget.units!.keys.toList(),
                            value: toUnit,
                            onChanged: (v) => setState(() => toUnit = v!),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: convert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                ),
                child: const Text("Convert"),
              ),
              const SizedBox(height: 14),
              Text(
                "Result: ${resultValue.toStringAsFixed(4)}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String label;
  final Function(String) onChanged;

  const CustomInputField({
    super.key,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: onChanged,
    );
  }
}

class UnitDropdown extends StatelessWidget {
  final List<String> units;
  final String value;
  final Function(String?) onChanged;

  const UnitDropdown({
    super.key,
    required this.units,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: units
          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}

class TemperatureDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  const TemperatureDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const units = ["Celsius", "Fahrenheit", "Kelvin"];
    return DropdownButtonFormField<String>(
      value: value,
      items: units
          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}
// Testing my main branch
// Im commiting
// Login
// github commit
// calculation
// Project
// Unit Converter App
// Flutter