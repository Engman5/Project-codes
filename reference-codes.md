# Model Code

'''
class Appliance {
  late final String id;
  final String name;
  final double power;
  final double hoursPerDay;
  final String consumerType;
  final bool isExclusive;

  Appliance({
    required this.id,
    required this.name,
    required this.power,
    required this.hoursPerDay,
    required this.consumerType,
    required this.isExclusive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'power': power,
      'hoursPerDay': hoursPerDay,
      'consumerType': consumerType,
      'isExclusive': isExclusive,
    };
  }

  factory Appliance.fromMap(Map<String, dynamic> map) {
    return Appliance(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Unknown Appliance',
      power: (map['power'] as num?)?.toDouble() ?? 0.0,
      hoursPerDay: (map['hoursPerDay'] as num?)?.toDouble() ?? 0.0,
      consumerType: map['consumerType'] as String? ?? 'Residential',
      isExclusive: map['isExclusive'] as bool? ?? false,
    );
  }
'''

# Calculation Function
'''
  double calculateMonthlyConsumption() {
    return power * hoursPerDay * 30 / 1000; // Convert to kWh
  }

  double calculateCost() {
    double consumption = calculateMonthlyConsumption();
    double cost = 0;
    if (consumerType == 'Residential') {
      if (isExclusive) {
        if (consumption <= 30) {
          cost = consumption * 0.65;
        } else {
          cost = 30 * 0.65 + (consumption - 30) * 1.49;
        }
      } else {
        if (consumption <= 300) {
          cost = consumption * 1.49 + 10.73; // Including service charge
        } else {
          cost = 300 * 1.49 +
              (consumption - 300) * 1.96 +
              10.73; // Including service charge
        }
      }
    } else if (consumerType == 'Non-Residential') {
      if (consumption <= 300) {
        cost = consumption * 1.34 + 12.43; // Including service charge
      } else {
        cost = 300 * 1.34 +
            (consumption - 300) * 1.67 +
            12.43; // Including service charge
      }
    }
    return cost;
  }
}

'''

# Pie Chart Codes

'''
const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                      pieTouchData: PieTouchData(
                                        touchCallback: (FlTouchEvent event,
                                            pieTouchResponse) {
                                          // Handle touch events
                                        },
                                      ),
                                      borderData: FlBorderData(show: false),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 40,
                                      sections:
                                          _createPieChartSections(appliances),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _createLegend(appliances),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Total Consumption: ${appliances.fold(0.0, (sum, a) => sum + a.calculateMonthlyConsumption()).toStringAsFixed(2)} kWh',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            'Total Cost: GHS ${appliances.fold(0.0, (sum, a) => sum + a.calculateCost()).toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Consumption Analysis',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: appliances.length,
                      itemBuilder: (context, index) {
                        final appliance = appliances[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text(
                              appliance.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Power: ${appliance.power} W',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  'Usage: ${appliance.hoursPerDay} hours/day',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  'Monthly Consumption: ${appliance.calculateMonthlyConsumption().toStringAsFixed(2)} kWh',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  'Monthly Cost: GHS ${appliance.calculateCost().toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading appliances.'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
     
  List<PieChartSectionData> _createPieChartSections(
      List<Appliance> appliances) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.cyan,
    ];
    final colorMap = <Appliance, Color>{};
    for (var i = 0; i < appliances.length; i++) {
      colorMap[appliances[i]] = colors[i % colors.length];
    }
    return appliances.asMap().entries.map((entry) {
      final index = entry.key;
      final appliance = entry.value;
      final consumption = appliance.calculateMonthlyConsumption();
      final isTouched = index == _touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = colorMap[appliance]!;

      return PieChartSectionData(
        color: color,
        value: consumption,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  final int _touchedIndex = -1;

  List<Widget> _createLegend(List<Appliance> appliances) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.cyan,
    ];
    final colorMap = <Appliance, Color>{};
    for (var i = 0; i < appliances.length; i++) {
      colorMap[appliances[i]] = colors[i % colors.length];
    }

'''