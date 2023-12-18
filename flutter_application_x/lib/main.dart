//Mustafa Erdogan 02200201029
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_x/firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kütüphane Yönetimi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    LibraryManagementPage(),
    BuyPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mustafa Erdogan Kütüphane Yönetimi'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Kitaplar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Satın Al',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(72,129,242, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}
class LibraryManagementPage extends StatefulWidget {
  @override
  _LibraryManagementPageState createState() => _LibraryManagementPageState();
}

class _LibraryManagementPageState extends State<LibraryManagementPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('books').where('should_be_listed', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Kitap bulunamadı.'));
          }
          return ListView.builder(
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context, index) {
    DocumentSnapshot document = snapshot.data!.docs[index];
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Color.fromRGBO(247, 242, 249, 1),
      child: ListTile(
        title: Text(
          data['name'] ?? '',
          style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Text('Yazar: ${data['author'] ?? ''}, Sayfa Sayısı: ${data['page_count'] ?? ''}'),
        trailing: Wrap(
          spacing: -10, 
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit, color: Colors.grey[850]),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookFormPage(document: document),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.grey[850]),
              onPressed: () => _confirmDeleteBook(document.id),                      ),
                      
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookFormPage()),
        ),
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
  void _confirmDeleteBook(String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kitabı Sil'),
          content: Text('Bu kitabı silmek istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Sil'),
              onPressed: () {
                firestore.collection('books').doc(docId).delete();
                Navigator.of(context).pop();
                Fluttertoast.showToast(msg: 'Kitap silindi.');
              },
            ),
          ],
        );
      },
    );
  }
}
class BookFormPage extends StatefulWidget {
  final DocumentSnapshot? document;

  BookFormPage({this.document});

  @override
  _BookFormPageState createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _pageCountController = TextEditingController();
  final TextEditingController _publicationYearController = TextEditingController();
  String _selectedCategory = 'Roman';
  bool _shouldBeListed = false;

  @override
  void initState() {
    super.initState();
    if (widget.document != null) {
      final data = widget.document!.data() as Map<String, dynamic>;
      _bookNameController.text = data['name'];
      _publisherController.text = data['publisher'];
      _authorController.text = data['author'];
      _pageCountController.text = data['page_count'].toString();
      _publicationYearController.text = data['publication_year'].toString();
      _selectedCategory = data['category'];
      _shouldBeListed = data['should_be_listed'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document == null ? 'Kitap Ekle' : 'Kitap Düzenle'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _bookNameController,
              decoration: InputDecoration(labelText: 'Kitap Adı'),
            ),
            TextFormField(
              controller: _publisherController,
              decoration: InputDecoration(labelText: 'Yayınevi'),
            ),
            TextFormField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Yazar/Yazarlar'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (newValue) => setState(() => _selectedCategory = newValue!),
              items: <String>['Roman', 'Tarih', 'Edebiyat', 'Şiir', 'Ansiklopedi']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Kategori'),
            ),
            TextFormField(
              controller: _pageCountController,
              decoration: InputDecoration(labelText: 'Sayfa Sayısı'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _publicationYearController,
              decoration: InputDecoration(labelText: 'Basım Yılı'),
              keyboardType: TextInputType.number,
            ),CheckboxListTile(
  title: Text('Listede Yayınlanacak mı?'),
  value: _shouldBeListed,
  onChanged: (bool? newValue) {
    setState(() {
      _shouldBeListed = newValue!;
    });
  },
  controlAffinity: ListTileControlAffinity.trailing, 
  contentPadding: EdgeInsets.symmetric(horizontal: 20), 
),
            ElevatedButton(
  onPressed: _addOrUpdateBook,
  child: Text('Kaydet'),
  style: ElevatedButton.styleFrom(
    onPrimary: Color.fromRGBO(126, 106, 178, 1),
    backgroundColor: const Color.fromRGBO(247, 242, 249, 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0), 
    ),
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), 
  ),
),
          ],
        ),
      ),
    );
  }

  void _addOrUpdateBook() async {
    Map<String, dynamic> bookData = {
      'name': _bookNameController.text,
      'publisher': _publisherController.text,
      'author': _authorController.text,
      'category': _selectedCategory,
      'page_count': int.tryParse(_pageCountController.text) ?? 0,
      'publication_year': int.tryParse(_publicationYearController.text) ?? 0,
      'should_be_listed': _shouldBeListed,
    };

    if (widget.document == null) {
      await firestore.collection('books').add(bookData);
      Fluttertoast.showToast(msg: 'Kitap  eklendi.');
    } else {
      await firestore.collection('books').doc(widget.document!.id).update(bookData);
      Fluttertoast.showToast(msg: 'Kitap güncellendi.');
    }

    Navigator.pop(context);
  }
}

class BuyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Satın Al Sayfası'),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Ayarlar Sayfası'),
    );
  }
}


