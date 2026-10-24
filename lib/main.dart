import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ===== MODEL DATA =====
class Pokemon {
  final int id, hp, attack, defense;
  final String name, description;
  final List<String> types;
  bool isFavorite = false;

  Pokemon(this.id, this.name, this.types, this.hp, this.attack, this.defense,
      this.description);

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/'
      'pokemon/other/official-artwork/$id.png';

  String get number => '#${id.toString().padLeft(3, '0')}';
}

// Objek berisi data pribadi
class Trainer {
  final String nama, nim, kampus;
  const Trainer(this.nama, this.nim, this.kampus);
}

const tipeWarna = <String, MaterialColor>{
  'Api': Colors.deepOrange,
  'Air': Colors.blue,
  'Rumput': Colors.green,
  'Listrik': Colors.amber,
  'Normal': Colors.blueGrey,
  'Psikis': Colors.pink,
  'Racun': Colors.deepPurple,
  'Peri': Colors.purple,
  'Hantu': Colors.indigo,
  'Naga': Colors.teal,
  'Terbang': Colors.lightBlue,
  'Bertarung': Colors.brown,
  'Baja': Colors.grey,
};

MaterialColor warnaTipe(String tipe) => tipeWarna[tipe] ?? Colors.grey;

// ===== MYAPP =====
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Katalog Pokémon',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.red, foregroundColor: Colors.white),
        ),
        home: const HomePage(),
      );
}

// ===== HALAMAN UTAMA =====
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _kategori = ['Semua', 'Favorit', 'Api', 'Air', 'Rumput', 'Listrik', 'Normal', 'Psikis'];
  String _kategoriDipilih = 'Semua', _kataKunci = '';
  final _pelatih =
      const Trainer('Yusuf Habibi Herbin', '202432066', 'Institut Teknologi PLN');

  final _daftarPokemon = [
    Pokemon(1, 'Bulbasaur', ['Rumput', 'Racun'], 45, 49, 49,
        'Biji di punggungnya tumbuh bersama dirinya sejak lahir dan '
        'menyerap sinar matahari sebagai sumber energi.'),
    Pokemon(4, 'Charmander', ['Api'], 39, 52, 43,
        'Api di ujung ekornya menandakan kondisinya. Nyalanya membesar '
        'saat ia bersemangat dan mengecil saat lemah.'),
    Pokemon(7, 'Squirtle', ['Air'], 44, 48, 65,
        'Setelah lahir, punggungnya mengeras menjadi cangkang. Ia '
        'menyemprotkan air dengan kuat dari mulutnya.'),
    Pokemon(25, 'Pikachu', ['Listrik'], 35, 55, 40,
        'Kantong pipinya menyimpan listrik. Saat terancam, ia '
        'melepaskan listrik tersebut sekaligus.'),
    Pokemon(39, 'Jigglypuff', ['Normal', 'Peri'], 115, 45, 20,
        'Nyanyiannya membuat lawan mengantuk. Matanya yang besar '
        'dan bulat membuatnya terlihat menggemaskan.'),
    Pokemon(94, 'Gengar', ['Hantu', 'Racun'], 60, 65, 60,
        'Konon ia bersembunyi di bayangan dan menurunkan suhu '
        'ruangan di sekitar targetnya.'),
    Pokemon(133, 'Eevee', ['Normal'], 55, 55, 50,
        'Tubuhnya yang tidak stabil memungkinkan ia berevolusi ke '
        'banyak bentuk sesuai lingkungannya.'),
    Pokemon(143, 'Snorlax', ['Normal'], 160, 110, 65,
        'Ia makan hampir sepanjang hari lalu tidur. Perutnya yang '
        'besar bahkan sering dipakai anak-anak sebagai tempat bermain.'),
    Pokemon(149, 'Dragonite', ['Naga', 'Terbang'], 91, 134, 95,
        'Walau bertubuh besar, ia mampu mengelilingi dunia dalam '
        'waktu singkat dan dikenal ramah pada pelaut yang tersesat.'),
    Pokemon(150, 'Mewtwo', ['Psikis'], 106, 110, 90,
        'Pokémon hasil rekayasa genetika dengan kekuatan psikis '
        'yang sangat besar.'),
    Pokemon(282, 'Gardevoir', ['Psikis', 'Peri'], 68, 65, 65,
        'Ia rela mengorbankan dirinya demi melindungi pelatih yang '
        'dipercayainya dan mampu membuat lubang hitam kecil.'),
    Pokemon(448, 'Lucario', ['Bertarung', 'Baja'], 70, 110, 70,
        'Ia dapat merasakan aura makhluk hidup dan membaca perasaan '
        'lawan dari jarak jauh.'),
  ];

  // Hasil setelah pencarian dan filter diterapkan
  List<Pokemon> get _hasilFilter => _daftarPokemon.where((p) {
        final cocokNama = p.name.toLowerCase().contains(_kataKunci.toLowerCase());
        final cocokKategori = _kategoriDipilih == 'Semua' ||
            (_kategoriDipilih == 'Favorit'
                ? p.isFavorite
                : p.types.contains(_kategoriDipilih));
        return cocokNama && cocokKategori;
      }).toList();

  int get _jumlahFavorit => _daftarPokemon.where((p) => p.isFavorite).length;

  void _resetFavorit() => setState(() {
        for (final p in _daftarPokemon) {
          p.isFavorite = false;
        }
      });

  void _toggleFavorit(Pokemon p) {
    setState(() => p.isFavorite = !p.isFavorite);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(p.isFavorite
            ? '${p.name} ditambahkan ke favorit'
            : '${p.name} dihapus dari favorit'),
        duration: const Duration(seconds: 1),
      ));
  }

  void _tampilkanDetail(Pokemon p) {
    final warna = warnaTipe(p.types.first);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
                color: warna.shade100, borderRadius: BorderRadius.circular(16)),
            child: PokemonImage(pokemon: p, size: 140),
          ),
          const SizedBox(height: 14),
          Text('${p.name}  ${p.number}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: p.types.map((t) => TypeChip(tipe: t)).toList(),
          ),
          const SizedBox(height: 12),
          Text(p.description, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          _barisStatistik('HP', p.hp, warna),
          _barisStatistik('Attack', p.attack, warna),
          _barisStatistik('Defense', p.defense, warna),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(sheetContext);
                _toggleFavorit(p);
              },
              icon: Icon(p.isFavorite ? Icons.favorite_border : Icons.favorite),
              label: Text(
                  p.isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _barisStatistik(String label, int nilai, MaterialColor warna) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          SizedBox(width: 70, child: Text(label)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (nilai / 180).clamp(0.0, 1.0),
                minHeight: 10,
                backgroundColor: warna.shade50,
                color: warna.shade400,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 32,
            child: Text('$nilai',
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final hasil = _hasilFilter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My PokéDex'),
        actions: [
          const Icon(Icons.favorite, size: 20),
          const SizedBox(width: 4),
          Center(
            child: Text('$_jumlahFavorit',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(children: [
        TrainerCard(
          pelatih: _pelatih,
          favorit: _jumlahFavorit,
          onReset: _resetFavorit,
        ),
        // Kolom pencarian
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari Pokémon...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.red.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (teks) => setState(() => _kataKunci = teks),
          ),
        ),
        // Filter kategori
        SizedBox(
          height: 52,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: _kategori.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => ChoiceChip(
              label: Text(_kategori[i]),
              selected: _kategoriDipilih == _kategori[i],
              onSelected: (_) => setState(() => _kategoriDipilih = _kategori[i]),
            ),
          ),
        ),
        // Grid kartu Pokémon
        Expanded(
          child: hasil.isEmpty
              ? const Center(child: Text('Pokémon tidak ditemukan'))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: hasil.length,
                  itemBuilder: (_, i) => PokemonCard(
                    pokemon: hasil[i],
                    onTap: () => _tampilkanDetail(hasil[i]),
                    onFavorite: () => _toggleFavorit(hasil[i]),
                  ),
                ),
        ),
      ]),
    );
  }
}

// ===== KARTU RINGKASAN PELATIH =====
class TrainerCard extends StatelessWidget {
  final Trainer pelatih;
  final int favorit;
  final VoidCallback onReset;

  const TrainerCard({
    super.key,
    required this.pelatih,
    required this.favorit,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration:
                  const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pelatih.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('${pelatih.nim} • ${pelatih.kampus}',
                      style: const TextStyle(fontSize: 12)),
                  Text('Favorit: $favorit Pokémon',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: onReset, child: const Text('Reset')),
          ]),
        ),
      );
}

// ===== KARTU INFORMASI POKÉMON =====
class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback onTap, onFavorite;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final warna = warnaTipe(pokemon.types.first);

    return Card(
      color: warna.shade50,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(pokemon.number,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: warna.shade700)),
              InkWell(
                onTap: onFavorite,
                child: Icon(
                    pokemon.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red),
              ),
            ]),
            Expanded(child: PokemonImage(pokemon: pokemon, size: 110)),
            Text(pokemon.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 4,
              children: pokemon.types.map((t) => TypeChip(tipe: t)).toList(),
            ),
          ]),
        ),
      ),
    );
  }
}

// Label tipe Pokémon
class TypeChip extends StatelessWidget {
  final String tipe;
  const TypeChip({super.key, required this.tipe});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
            color: warnaTipe(tipe).shade400,
            borderRadius: BorderRadius.circular(12)),
        child: Text(tipe,
            style: const TextStyle(
                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
      );
}

// Gambar Pokémon dengan ikon cadangan jika gambar gagal dimuat
class PokemonImage extends StatelessWidget {
  final Pokemon pokemon;
  final double size;
  const PokemonImage({super.key, required this.pokemon, required this.size});

  @override
  Widget build(BuildContext context) {
    final warna = warnaTipe(pokemon.types.first);

    return Image.network(
      pokemon.imageUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Center(child: CircularProgressIndicator(color: warna.shade400)),
      errorBuilder: (_, __, ___) =>
          Icon(Icons.catching_pokemon, size: size * 0.6, color: warna.shade400),
    );
  }
}