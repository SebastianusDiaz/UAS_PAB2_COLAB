import '../model/venue.dart';

final List<Venue> venues = [
  Venue(
    id: '1',
    name: 'Kumbang Basketball Hall',
    whatsappNumber: '62895807069922',
    address:
        'Jl. H. Abdul Rozak, 8 Ilir, Kec. Ilir Tim. II, Kota Palembang, Sumatera Selatan 30163',
    image: 'images/venue1.jpg',
    description: 'Venue dengan beberapa lapangan olahraga.',
    facilities: ['Ruang Ganti', 'Parkir Luas', 'Kantin'],
    rating: 4.5,
    openHours: '07:00 - 22:00',
    category: 'Basketball',
    latitude: -2.990934,
    longitude: 104.757722,
    reviews: [
      {'name': 'Andi', 'comment': 'Lapangan bagus dan bersih!', 'rating': 5},
      {
        'name': 'Budi',
        'comment': 'Cukup memuaskan meski parkir agak penuh.',
        'rating': 4
      },
    ],
    fields: [
      Field(name: 'Lapangan A', morningPrice: 80000, afternoonPrice: 100000),
      Field(name: 'Lapangan B', morningPrice: 75000, afternoonPrice: 95000),
    ],
  ),
  Venue(
    id: '2',
    name: 'Naga Jaya Badminton Hall',
    whatsappNumber: '6281393820186',
    address:
        ' Duku, Kec. Ilir Tim. II, Kota Palembang, Sumatera Selatan 30163 ',
    image: 'images/venue2.jpg',
    description: 'Terdapat 4 Lapangan yang bisa kalian nikmati.',
    facilities: ['Ruang Ganti', 'Kantin', 'Parkiran', 'Toilet'],
    rating: 4.6,
    openHours: '07:00 - 22:00',
    category: 'Badminton',
    latitude: -2.964825,
    longitude: 104.771671,
    reviews: [
      {
        'name': 'Erik',
        'comment': 'Tempat nyaman dan Parkiran Luas',
        'rating': 4
      },
      {
        'name': 'Nelsen',
        'comment': 'Harga sesuai kualitas, overall oke.',
        'rating': 5
      },
    ],
    fields: [
      Field(name: 'Lapangan A', morningPrice: 80000, afternoonPrice: 100000),
      Field(name: 'Lapangan B', morningPrice: 80000, afternoonPrice: 100000),
    ],
  ),
  Venue(
    id: '3',
    name: 'Dharma Jaya Badminton',
    whatsappNumber: '6281393820186',
    address:
        'Jl. Bay Salim No.46, Sekip Jaya, Kec. Ilir Tim. I, Kota Palembang, Sumatera Selatan 30114',
    image: 'images/venue3.jpg',
    description: 'Terdapat 3 lapangan yang bisa kalian gunakan.',
    facilities: ['Parkiran', 'Ruang Ganti & Toilet', 'Kantin'],
    rating: 4.5,
    openHours: '07:00 - 22:00',
    category: 'Badminton',
    latitude: -2.971584,
    longitude: 104.759832,
    reviews: [
      {'name': 'Hansen', 'comment': 'Tempat Nyaman dan Luas', 'rating': 5},
      {
        'name': 'Budi',
        'comment': 'lokasi di berdekatan dengan banyak resto',
        'rating': 4
      },
    ],
    fields: [
      Field(name: 'Lapangan A', morningPrice: 80000, afternoonPrice: 100000),
      Field(name: 'Lapangan B', morningPrice: 80000, afternoonPrice: 100000),
    ],
  ),
  Venue(
    id: '4',
    name: 'BOOM Futsal ',
    whatsappNumber: '6281393820186',
    address:
        'Jl. Bay Salim No.1, Sekip Jaya, Kec. Kemuning, Kota Palembang, Sumatera Selatan 30126',
    image: 'images/venue4.jpg',
    description: 'Lapangan futsal indoor dengan 3 lapangan.',
    facilities: ['Ruang Ganti', 'Parkiran', 'Kantin'],
    rating: 4.6,
    openHours: '07:00 - 22:00',
    category: 'Soccer',
    latitude: -2.971877,
    longitude: 104.759812,
    reviews: [
      {'name': 'yanto', 'comment': 'Tempat nyaman dan luas', 'rating': 5},
      {
        'name': 'desi',
        'comment': 'Tempat nya enak dan petugas nya ramah.',
        'rating': 4
      },
    ],
    fields: [
      Field(name: 'Lapangan A', morningPrice: 100000, afternoonPrice: 150000),
      Field(name: 'Lapangan B', morningPrice: 100000, afternoonPrice: 150000),
    ],
  ),
  Venue(
    id: '5',
    name: 'Prioritas Minisoccer',
    whatsappNumber: '6281393820186',
    address:
        'Jl. Ong Len, 9 Ilir, Kec. Ilir Tim. II, Kota Palembang, Sumatera Selatan 30114',
    image: 'images/venue5.jpg',
    description: 'Lapangan Minisocer outdoor.',
    facilities: ['Ruang Ganti', 'Toilet', 'Parkiran'],
    rating: 4.6,
    openHours: '07:00 - 22:00',
    category: 'Soccer',
    latitude: -2.973611,
    longitude: 104.761161,
    reviews: [
      {'name': 'Mikael', 'comment': 'Tempat luas dan enak', 'rating': 5},
      {
        'name': 'Tian',
        'comment': 'Rumputnya enak untuk main minisoccer',
        'rating': 4
      },
    ],
    fields: [
      Field(name: 'Lapangan A', morningPrice: 200000, afternoonPrice: 300000),
      Field(name: 'Lapangan B', morningPrice: 200000, afternoonPrice: 300000),
    ],
  ),
  Venue(
    id: '6',
    name: 'Bangau Bakset Hall',
    whatsappNumber: '6281393820186',
    address:
        'Lorong Hasyiman, 9 Ilir, Kec. Ilir Tim. II, Kota Palembang, Sumatera Selatan 30114',
    image: 'images/venue2.jpg',
    description: 'Tersedia Lapangan Indoor dan Outdoor',
    facilities: ['Ruang Ganti', 'Parkiran', 'Toilet'],
    rating: 4.5,
    openHours: '07:00 - 22:00',
    category: 'Basket',
    latitude: -2.966257,
    longitude: 104.762570,
    reviews: [
      {'name': 'Hasan', 'comment': 'Pelayanan yang bagus', 'rating': 5},
      {
        'name': 'Yanti',
        'comment': 'Ada Gym juga di sebelah lapangan nya',
        'rating': 4
      },
    ],
    fields: [
      Field(name: 'Lapangan A', morningPrice: 100000, afternoonPrice: 150000),
      Field(name: 'Lapangan B', morningPrice: 100000, afternoonPrice: 150000),
    ],
  ),
  Venue(
    id: '7',
    name: 'Duta Jaya Basketball Court',
    whatsappNumber: '6281393820186',
    address:
        'Kemang Manis, Kec. Ilir Bar. II, Kota Palembang, Sumatera Selatan',
    image: 'images/venue2.jpg',
    description: 'Tersedia Lapangan Indoor dengan standar nasional ',
    facilities: ['Ruang Ganti', 'Kantin', 'Parkiran'],
    rating: 4.6,
    openHours: '07:00 - 22:00',
    category: 'Basket',
    latitude: -2.992292,
    longitude: 104.737218,
    reviews: [
      {'name': 'Asep', 'comment': 'Tempat nyaman', 'rating': 5},
      {'name': 'Ferdi', 'comment': 'Tempatnya oke untuk lomba', 'rating': 4},
    ],
    fields: [
      Field(name: 'Lapangan A', morningPrice: 150000, afternoonPrice: 200000),
      Field(name: 'Lapangan B', morningPrice: 150000, afternoonPrice: 200000),
    ],
  ),
  Venue(
    id: '8',
    name: 'Osbond Gym',
    whatsappNumber: '6281393820186',
    address:
        'Jl. Rajawali No.465 Blok AA s/d AH, 9 Ilir, Kec. Ilir Tim. II, Kota Palembang, Sumatera Selatan 30114',
    image: 'images/venue8.jpg',
    description: 'Gym indoor ber-AC dengan fasilitas yang lengkap.',
    facilities: ['Ruang Ganti', 'Parkiran', 'AC'],
    rating: 4.6,
    openHours: '07:00 - 22:00',
    category: 'Gym',
    latitude: -2.972237,
    longitude: 104.764293,
    reviews: [
      {'name': 'Susi', 'comment': 'Tempat nyaman dan ber-AC!', 'rating': 5},
      {
        'name': 'Dewi',
        'comment': 'Harga sesuai kualitas, overall oke.',
        'rating': 4
      },
    ],
    fields: [
      Field(name: 'Lapangan A', morningPrice: 80000, afternoonPrice: 100000),
      Field(name: 'Lapangan B', morningPrice: 80000, afternoonPrice: 100000),
    ],
  ),
  Venue(
    id: '9',
    name: 'Okami Fitness',
    whatsappNumber: '6281393820186',
    address:
        'Jl. Kolonel H. Barlian No.188 KM9, Karya Baru, Kec. Alang-Alang Lebar, Kota Palembang, Sumatera Selatan 30152',
    image: 'images/venue9.jpg',
    description: 'Gym dengan fasilitas lengkap dan nyaman.',
    facilities: ['Ruang Ganti', 'Wifi', 'AC'],
    rating: 4.8,
    openHours: '07:00 - 22:00',
    category: 'Gym',
    latitude: -2.926600,
    longitude: 104.714508,
    reviews: [
      {'name': 'Ronaldo', 'comment': 'Tempat nyaman dan ber-AC!', 'rating': 5},
      {
        'name': 'Messi',
        'comment': 'Harga sesuai kualitas, overall oke.',
        'rating': 4
      },
    ],
    fields: [
      Field(name: 'Lapangan A', morningPrice: 80000, afternoonPrice: 100000),
      Field(name: 'Lapangan B', morningPrice: 80000, afternoonPrice: 100000),
    ],
  ),
];
