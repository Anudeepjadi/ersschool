import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions.dart';

class StudentItem {
  final String name;
  final String className;
  final String rollNo;
  final String admissionNo;
  final String gender;
  final String parentName;
  final bool isActive;
  final String avatarUrl;
  final List<String> siblings;
  final bool hasIdCard;

  StudentItem({
    required this.name,
    required this.className,
    required this.rollNo,
    required this.admissionNo,
    required this.gender,
    required this.parentName,
    required this.isActive,
    required this.avatarUrl,
    this.siblings = const [],
    this.hasIdCard = true,
  });
}

class StudentsScreen extends StatefulWidget {
  final int activeTab;
  final Function(int) onSubTabSelected;

  const StudentsScreen({
    super.key,
    this.activeTab = 0,
    required this.onSubTabSelected,
  });

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String selectedClass = "Class 8 - A";
  String searchQuery = "";
  String statusFilter = "All"; // All, Active, Inactive
  String statsFilter = "Total"; // Total, Boys, Girls, Present, Absent
  int currentPage = 1;
  final int itemsPerPage = 8;

  // Mock list of 42 students to make pagination work beautifully
  late List<StudentItem> _students;

  @override
  void initState() {
    super.initState();
    _students = [
      StudentItem(
        name: "Aarav Sharma",
        className: "Class 8 - A",
        rollNo: "01",
        admissionNo: "ADMO0123",
        gender: "Male",
        parentName: "Rohit Sharma",
        isActive: true,
        avatarUrl: "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100",
        siblings: ["Ananya Sharma"],
        hasIdCard: true,
      ),
      StudentItem(
        name: "Ananya Sharma",
        className: "Class 8 - A",
        rollNo: "02",
        admissionNo: "ADMO0124",
        gender: "Female",
        parentName: "Rohit Sharma",
        isActive: true,
        avatarUrl: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100",
        siblings: ["Aarav Sharma"],
        hasIdCard: false,
      ),
      StudentItem(
        name: "Vivaan Mehta",
        className: "Class 8 - A",
        rollNo: "03",
        admissionNo: "ADMO0125",
        gender: "Male",
        parentName: "Sandeep Mehta",
        isActive: true,
        avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100",
        hasIdCard: true,
      ),
      StudentItem(
        name: "Myra Singh",
        className: "Class 8 - A",
        rollNo: "04",
        admissionNo: "ADMO0126",
        gender: "Female",
        parentName: "Pooja Singh",
        isActive: true,
        avatarUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100",
        hasIdCard: true,
      ),
      StudentItem(
        name: "Arjun Gupta",
        className: "Class 8 - A",
        rollNo: "05",
        admissionNo: "ADMO0127",
        gender: "Male",
        parentName: "Amit Gupta",
        isActive: true,
        avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100",
        hasIdCard: false,
      ),
      StudentItem(
        name: "Diya Patel",
        className: "Class 8 - A",
        rollNo: "06",
        admissionNo: "ADMO0128",
        gender: "Female",
        parentName: "Kiran Patel",
        isActive: false,
        avatarUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100",
        hasIdCard: true,
      ),
    ];

    // Generate padding items up to 42 students total for Class 8 - A
    for (int i = 7; i <= 42; i++) {
      _students.add(StudentItem(
        name: "Student $i",
        className: "Class 8 - A",
        rollNo: i.toString().padLeft(2, '0'),
        admissionNo: "ADMO01${122 + i}",
        gender: i % 2 == 0 ? "Female" : "Male",
        parentName: "Parent $i",
        isActive: i % 7 != 0,
        avatarUrl: "https://images.unsplash.com/photo-${1500000000000 + i}?w=100",
        hasIdCard: i % 3 != 0,
        siblings: i % 10 == 0 ? ["Sibling of Student $i"] : [],
      ));
    }

    // Additional classes
    _students.add(StudentItem(name: "Rahul Dravid", className: "Class 9 - A", rollNo: "01", admissionNo: "ADMO0201", gender: "Male", parentName: "Sharad Dravid", isActive: true, avatarUrl: "https://images.unsplash.com/photo-1542909168-82c3e7fdca5c?w=100"));
    _students.add(StudentItem(name: "Sania Mirza", className: "Class 9 - A", rollNo: "02", admissionNo: "ADMO0202", gender: "Female", parentName: "Imran Mirza", isActive: true, avatarUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100"));
  }

  void _showAddStudentDialog() {
    final nameController = TextEditingController();
    final rollController = TextEditingController();
    final admissionController = TextEditingController();
    final parentController = TextEditingController();
    String gender = "Male";
    bool isActive = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("Add New Student"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Student Name"),
                    ),
                    TextField(
                      controller: rollController,
                      decoration: const InputDecoration(labelText: "Roll No"),
                    ),
                    TextField(
                      controller: admissionController,
                      decoration: const InputDecoration(labelText: "Admission No"),
                    ),
                    TextField(
                      controller: parentController,
                      decoration: const InputDecoration(labelText: "Parent Name"),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text("Gender: "),
                        Radio<String>(
                          value: "Male",
                          groupValue: gender,
                          onChanged: (val) {
                            setModalState(() {
                              gender = val!;
                            });
                          },
                        ),
                        const Text("Male"),
                        Radio<String>(
                          value: "Female",
                          groupValue: gender,
                          onChanged: (val) {
                            setModalState(() {
                              gender = val!;
                            });
                          },
                        ),
                        const Text("Female"),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Status: "),
                        Switch(
                          value: isActive,
                          onChanged: (val) {
                            setModalState(() {
                              isActive = val;
                            });
                          },
                        ),
                        Text(isActive ? "Active" : "Inactive"),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        _students.insert(
                          0,
                          StudentItem(
                            name: nameController.text,
                            className: selectedClass,
                            rollNo: rollController.text.isNotEmpty ? rollController.text : "99",
                            admissionNo: admissionController.text.isNotEmpty ? admissionController.text : "ADMO0999",
                            gender: gender,
                            parentName: parentController.text.isNotEmpty ? parentController.text : "TBD",
                            isActive: isActive,
                            avatarUrl: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100",
                          ),
                        );
                        currentPage = 1;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${nameController.text} added successfully')),
                      );
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Filter by Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListTile(
                title: const Text("All"),
                trailing: statusFilter == "All" ? const Icon(Icons.check, color: Colors.blue) : null,
                onTap: () {
                  setState(() => statusFilter = "All");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Active Only"),
                trailing: statusFilter == "Active" ? const Icon(Icons.check, color: Colors.blue) : null,
                onTap: () {
                  setState(() => statusFilter = "Active");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Inactive Only"),
                trailing: statusFilter == "Inactive" ? const Icon(Icons.check, color: Colors.blue) : null,
                onTap: () {
                  setState(() => statusFilter = "Inactive");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSiblingsView() {
    final siblingsList = _students.where((st) => st.siblings.isNotEmpty && st.className == selectedClass).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("All Student Siblings (${siblingsList.length})", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        if (siblingsList.isEmpty)
          const Center(child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text("No siblings found for this class"),
          ))
        else
          ...siblingsList.map((st) => Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(st.avatarUrl)),
              title: Text(st.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Admission ID: ${st.admissionNo}", style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w600)),
                  Text("Siblings: ${st.siblings.join(", ")}", style: const TextStyle(fontSize: 12)),
                ],
              ),
              trailing: const Icon(Icons.group, color: Colors.blue),
            ),
          )),
      ],
    );
  }

  Widget _buildIdCardsView() {
    final classStudents = _students.where((st) => st.className == selectedClass).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("Student ID Cards (${classStudents.length})", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: classStudents.length,
          itemBuilder: (context, index) {
            final st = classStudents[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (st.hasIdCard) ...[
                    // ID Card Visual
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(radius: 35, backgroundImage: NetworkImage(st.avatarUrl)),
                    ),
                    const SizedBox(height: 8),
                    Text(st.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(st.className, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text("ID: ${st.admissionNo}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                      ),
                      child: const Center(child: Text("VIEW ID CARD", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                    ),
                  ] else ...[
                    // No ID Card Placeholder
                    const Icon(Icons.badge_outlined, size: 40, color: Colors.grey),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(st.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "No ID Card",
                      style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text("Adm: ${st.admissionNo}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                      ),
                      child: const Center(child: Text("GENERATE ID", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold))),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _importStudents() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.file_upload, color: Colors.blue),
            SizedBox(width: 8),
            Text("Import Students"),
          ],
        ),
        content: const Text("Directing to local disk... Select an Excel (.xlsx) or CSV file containing student records."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Importing data from selected file..."), backgroundColor: Colors.blue),
              );
            },
            child: const Text("Select File"),
          ),
        ],
      ),
    );
  }

  void _downloadStudentList() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            SizedBox(width: 12),
            Text("Generating Student List Excel..."),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student_List_Class_8A.xlsx downloaded to local storage."),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _generateIdCards() {
    final nameController = TextEditingController();
    final idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.badge, color: Colors.blue[800]),
            const SizedBox(width: 8),
            const Text("Create New ID Card"),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Enter student credentials to generate a custom ID card.", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Student Name",
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: "Student ID (Admission No)",
                  prefixIcon: const Icon(Icons.numbers_outlined, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Student Photo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Directing to local disk for photo selection...")));
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, color: Colors.blue[800], size: 30),
                      const SizedBox(height: 4),
                      Text("Upload Photo", style: TextStyle(color: Colors.blue[800], fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && idController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("ID Card generated for ${nameController.text}!"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all details")));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Generate"),
          ),
        ],
      ),
    );
  }

  void _editStudent(StudentItem student) {
    final nameController = TextEditingController(text: student.name);
    final rollController = TextEditingController(text: student.rollNo);
    final admissionController = TextEditingController(text: student.admissionNo);
    final parentController = TextEditingController(text: student.parentName);
    String gender = student.gender;
    bool isActive = student.isActive;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("Edit Student"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: "Student Name")),
                    TextField(controller: rollController, decoration: const InputDecoration(labelText: "Roll No")),
                    TextField(controller: admissionController, decoration: const InputDecoration(labelText: "Admission No"), enabled: false), // ID usually shouldn't change
                    TextField(controller: parentController, decoration: const InputDecoration(labelText: "Parent Name")),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text("Gender: "),
                        Radio<String>(value: "Male", groupValue: gender, onChanged: (val) => setModalState(() => gender = val!)),
                        const Text("Male"),
                        Radio<String>(value: "Female", groupValue: gender, onChanged: (val) => setModalState(() => gender = val!)),
                        const Text("Female"),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Status: "),
                        Switch(value: isActive, onChanged: (val) => setModalState(() => isActive = val)),
                        Text(isActive ? "Active" : "Inactive"),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      final index = _students.indexWhere((st) => st.admissionNo == student.admissionNo);
                      if (index != -1) {
                        _students[index] = StudentItem(
                          name: nameController.text,
                          className: student.className,
                          rollNo: rollController.text,
                          admissionNo: student.admissionNo,
                          gender: gender,
                          parentName: parentController.text,
                          isActive: isActive,
                          avatarUrl: student.avatarUrl,
                          siblings: student.siblings,
                          hasIdCard: student.hasIdCard,
                        );
                      }
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Student details updated")));
                  },
                  child: const Text("Save Changes"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteStudent(StudentItem student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Student"),
        content: Text("Are you sure you want to delete ${student.name}? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _students.removeWhere((st) => st.admissionNo == student.admissionNo);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${student.name} deleted"), backgroundColor: Colors.redAccent),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Filter students by selected class, search query, and status filter
    final filtered = _students.where((st) {
      final matchesClass = st.className == selectedClass;
      final matchesQuery = st.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          st.admissionNo.toLowerCase().contains(searchQuery.toLowerCase()) ||
          st.parentName.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = statusFilter == "All" ||
          (statusFilter == "Active" && st.isActive) ||
          (statusFilter == "Inactive" && !st.isActive);

      // Stats Filtering logic
      bool matchesStats = true;
      if (statsFilter == "Boys") {
        matchesStats = st.gender == "Male";
      } else if (statsFilter == "Girls") {
        matchesStats = st.gender == "Female";
      } else if (statsFilter == "Present Today") {
        // Only active students with even roll numbers are present
        matchesStats = st.isActive && int.tryParse(st.rollNo) != null && int.parse(st.rollNo) % 2 == 0;
      } else if (statsFilter == "Absent Today") {
        // Students who are NOT present (includes inactive and active-but-odd-roll)
        bool isPresent = st.isActive && int.tryParse(st.rollNo) != null && int.parse(st.rollNo) % 2 == 0;
        matchesStats = !isPresent;
      }

      return matchesClass && matchesQuery && matchesStatus && matchesStats;
    }).toList();

    // Stats calculations (always based on Class + Status + Search, but NOT statsFilter itself to show the numbers on cards)
    final baseFiltered = _students.where((st) {
      final matchesClass = st.className == selectedClass;
      final matchesQuery = st.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          st.admissionNo.toLowerCase().contains(searchQuery.toLowerCase()) ||
          st.parentName.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = statusFilter == "All" ||
          (statusFilter == "Active" && st.isActive) ||
          (statusFilter == "Inactive" && !st.isActive);
      return matchesClass && matchesQuery && matchesStatus;
    }).toList();

    final totalCountNum = baseFiltered.length;
    final boysCountNum = baseFiltered.where((st) => st.gender == "Male").length;
    final girlsCountNum = baseFiltered.where((st) => st.gender == "Female").length;
    final presentTodayNum = baseFiltered.where((st) => st.isActive && int.tryParse(st.rollNo) != null && int.parse(st.rollNo) % 2 == 0).length;
    final absentTodayNum = totalCountNum - presentTodayNum;

    // Pagination bounds
    final totalCount = filtered.length;
    final totalPages = (totalCount / itemsPerPage).ceil();
    final int safeTotalPages = totalPages == 0 ? 1 : totalPages;
    if (currentPage > safeTotalPages) {
      currentPage = safeTotalPages;
    }
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage > totalCount ? totalCount : startIndex + itemsPerPage;
    final pageItems = filtered.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Class Overview Selector Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Class Overview",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B263B),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButton<String>(
                    value: selectedClass,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                    style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedClass = newValue;
                          currentPage = 1;
                        });
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: "Class 8 - A", child: Text("Class 8 - A")),
                      DropdownMenuItem(value: "Class 9 - A", child: Text("Class 9 - A")),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Class Overview Stat Cards (Horizontal scroll)
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                StatCard(
                  title: "Total Students",
                  value: "$totalCountNum",
                  icon: Icons.people,
                  iconColor: Colors.blue,
                  iconBackgroundColor: Colors.blue.withValues(alpha: 0.1),
                  isSelected: statsFilter == "Total",
                  onTap: () => setState(() {
                    statsFilter = "Total";
                    currentPage = 1;
                  }),
                ),
                StatCard(
                  title: "Boys",
                  value: "$boysCountNum",
                  icon: Icons.male,
                  iconColor: Colors.green,
                  iconBackgroundColor: Colors.green.withValues(alpha: 0.1),
                  isSelected: statsFilter == "Boys",
                  onTap: () => setState(() {
                    statsFilter = "Boys";
                    currentPage = 1;
                  }),
                ),
                StatCard(
                  title: "Girls",
                  value: "$girlsCountNum",
                  icon: Icons.female,
                  iconColor: Colors.pink,
                  iconBackgroundColor: Colors.pink.withValues(alpha: 0.1),
                  isSelected: statsFilter == "Girls",
                  onTap: () => setState(() {
                    statsFilter = "Girls";
                    currentPage = 1;
                  }),
                ),
                StatCard(
                  title: "Present Today",
                  value: "$presentTodayNum",
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.purple,
                  iconBackgroundColor: Colors.purple.withValues(alpha: 0.1),
                  isSelected: statsFilter == "Present Today",
                  onTap: () => setState(() {
                    statsFilter = "Present Today";
                    currentPage = 1;
                  }),
                ),
                StatCard(
                  title: "Absent Today",
                  value: "$absentTodayNum",
                  icon: Icons.cancel_outlined,
                  iconColor: Colors.orange,
                  iconBackgroundColor: Colors.orange.withValues(alpha: 0.1),
                  isSelected: statsFilter == "Absent Today",
                  onTap: () => setState(() {
                    statsFilter = "Absent Today";
                    currentPage = 1;
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (widget.activeTab == 0) ...[
            // 3. Students List Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$statsFilter Students ($totalCount)",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B263B),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddStudentDialog,
                    icon: const Icon(Icons.add, size: 14, color: Colors.white),
                    label: const Text("Add Student", style: TextStyle(fontSize: 12, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 4. Search and Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        onChanged: (val) {
                          setState(() {
                            searchQuery = val;
                            currentPage = 1;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Search by name, roll no. or admission no.",
                          hintStyle: TextStyle(fontSize: 12),
                          prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: statusFilter == "All" ? Colors.grey[100] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusFilter == "All" ? Colors.grey[300]! : Colors.blue),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.tune, size: 18, color: statusFilter == "All" ? Colors.grey : Colors.blue),
                      onPressed: _showFilterSheet,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 5. Students Table View
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 600, // Fixed width for scrollable table effect
                    child: Column(
                      children: [
                        // Table Header Row
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Expanded(flex: 3, child: Text("Student Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey))),
                              Expanded(flex: 1, child: Text("Roll No.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.center)),
                              Expanded(flex: 2, child: Text("Admission No.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.center)),
                              Expanded(flex: 1, child: Text("Gender", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.center)),
                              Expanded(flex: 2, child: Text("Parent Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey))),
                              Expanded(flex: 2, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.center)),
                              Expanded(flex: 1, child: Text("Action", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.right)),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Colors.grey),
                        // Table Data Rows
                        if (pageItems.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text("No students found", style: TextStyle(color: Colors.grey)),
                          )
                        else
                          ...pageItems.map((st) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
                              ),
                              child: Row(
                                children: [
                                  // Student Name + Avatar
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundImage: NetworkImage(st.avatarUrl),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(st.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis),
                                              Text(st.className, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Roll Number
                                  Expanded(
                                    flex: 1,
                                    child: Text(st.rollNo, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                                  ),
                                  // Admission Number
                                  Expanded(
                                    flex: 2,
                                    child: Text(st.admissionNo, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                                  ),
                                  // Gender
                                  Expanded(
                                    flex: 1,
                                    child: Text(st.gender, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                                  ),
                                  // Parent Name
                                  Expanded(
                                    flex: 2,
                                    child: Text(st.parentName, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                                  ),
                                  // Status capsule
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: st.isActive ? Colors.green[50] : Colors.red[50],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          st.isActive ? "Active" : "Inactive",
                                          style: TextStyle(
                                            color: st.isActive ? Colors.green[800] : Colors.red[800],
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Action Menu Button
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _editStudent(st);
                                          } else if (value == 'delete') {
                                            _deleteStudent(st);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit, size: 18, color: Colors.blue),
                                                SizedBox(width: 8),
                                                Text("Edit", style: TextStyle(fontSize: 13)),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete, size: 18, color: Colors.red),
                                                SizedBox(width: 8),
                                                Text("Delete", style: TextStyle(fontSize: 13, color: Colors.red)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 6. Pagination Footer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Showing ${startIndex + 1} to $endIndex of $totalCount students",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left, size: 18),
                        onPressed: currentPage > 1
                            ? () {
                          setState(() {
                            currentPage--;
                          });
                        }
                            : null,
                      ),
                      ...List.generate(safeTotalPages, (index) {
                        final page = index + 1;
                        final isSelected = page == currentPage;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              currentPage = page;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue[800] : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: isSelected ? null : Border.all(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              "$page",
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                      IconButton(
                        icon: const Icon(Icons.arrow_right, size: 18),
                        onPressed: currentPage < safeTotalPages
                            ? () {
                          setState(() {
                            currentPage++;
                          });
                        }
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else if (widget.activeTab == 1)
            _buildSiblingsView()
          else if (widget.activeTab == 2)
              _buildIdCardsView(),

          const SizedBox(height: 12),

          // 7. Quick Actions Row
          QuickActionsBar(
            actions: [
              QuickActionItem(title: "Add Student", icon: Icons.add_circle_outline, onTap: _showAddStudentDialog),
              QuickActionItem(title: "Import Students", icon: Icons.file_upload_outlined, onTap: _importStudents),
              QuickActionItem(title: "Download Student List", icon: Icons.file_download_outlined, onTap: _downloadStudentList),
              QuickActionItem(title: "Generate ID Cards", icon: Icons.badge_outlined, onTap: _generateIdCards),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}