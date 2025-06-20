

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/venue.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import firebase_auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import cloud_firestore
import 'package:intl/intl.dart';

const kPrimaryColor = Color(0xFF06AEAF);
const kDefaultPadding = 16.0;
const kBorderRadius = 16.0;

class BookingScreen extends StatefulWidget {
  final Venue venue;
  final Field? field; // Make field nullable

  const BookingScreen({Key? key, required this.venue, this.field}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool isFavorite = false;
  DateTime selectedDate = DateTime.now();
  List<int> selectedHours = [];
  Field? selectedField; // Make selectedField nullable

  @override
  void initState() {
    super.initState();
    selectedField = widget.field ?? widget.venue.fields.first; // Initialize selectedField
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favoriteDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.venue.id)
        .get();

    setState(() {
      isFavorite = favoriteDoc.exists;
    });
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to manage favorites.')),
      );
      return;
    }

    final favoriteRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.venue.id);

    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      await favoriteRef.set(widget.venue.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.venue.name} added to favorites')),
      );
    } else {
      await favoriteRef.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.venue.name} removed from favorites')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedHours.clear(); // Clear selected hours when date changes
      });
    }
  }

  void _toggleHourSelection(int hour) {
    setState(() {
      if (selectedHours.contains(hour)) {
        selectedHours.remove(hour);
      } else {
        selectedHours.add(hour);
      }
      selectedHours.sort();
    });
  }

  int _calculateTotalPrice() {
    if (selectedField == null || selectedHours.isEmpty) {
      return 0;
    }
    int total = 0;
    for (int hour in selectedHours) {
      if (hour >= 7 && hour < 17) {
        // Morning hours (7 AM to 4 PM)
        total += selectedField!.morningPrice;
      } else {
        // Afternoon/Evening hours (5 PM to 10 PM)
        total += selectedField!.afternoonPrice;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          widget.venue.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVenueImage(),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVenueDetails(),
                  const SizedBox(height: kDefaultPadding),
                  _buildAboutSection(),
                  const SizedBox(height: kDefaultPadding),
                  _buildFacilities(),
                  const SizedBox(height: kDefaultPadding),
                  _buildMapSection(),
                  const SizedBox(height: kDefaultPadding),
                  _buildReviewsSection(),
                  const SizedBox(height: kDefaultPadding),
                  _buildFieldSelection(),
                  const SizedBox(height: kDefaultPadding),
                  _buildDatePicker(context),
                  const SizedBox(height: kDefaultPadding),
                  _buildTimeSlotSelection(),
                  const SizedBox(height: kDefaultPadding),
                  _buildTotalPrice(),
                  const SizedBox(height: kDefaultPadding),
                  _buildBookButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(kBorderRadius)),
      child: Image.asset(
        widget.venue.image,
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildVenueDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.venue.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.grey, size: 18),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.venue.address,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text(
              '${widget.venue.rating} (${widget.venue.reviews.length} reviews)',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.access_time, color: Colors.grey, size: 18),
            const SizedBox(width: 4),
            Text(
              'Open: ${widget.venue.openHours}',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Venue',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.venue.description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildFacilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Facilities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: widget.venue.facilities
              .map((facility) => Chip(
                    label: Text(facility),
                    backgroundColor: kPrimaryColor.withOpacity(0.1),
                    labelStyle: const TextStyle(color: kPrimaryColor),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(widget.venue.latitude, widget.venue.longitude),
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(widget.venue.latitude, widget.venue.longitude),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        if (widget.venue.reviews.isEmpty)
          const Text('No reviews yet.')
        else
          Column(
            children: widget.venue.reviews.map((review) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              review['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  size: 16,
                                  color: index < (review['rating'] as int)
                                      ? Colors.amber
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(review['comment']),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildFieldSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Field',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: widget.venue.fields.map((field) {
            final isSelected = selectedField?.name == field.name;
            return ChoiceChip(
              label: Text(field.name),
              selected: isSelected,
              selectedColor: kPrimaryColor,
              onSelected: (selected) {
                setState(() {
                  selectedField = field;
                  selectedHours.clear(); // Clear selected hours when field changes
                });
              },
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? kPrimaryColor : Colors.grey.shade400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd MMMM yyyy').format(selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.calendar_today, color: kPrimaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection() {
    if (selectedField == null) {
      return const Text('Please select a field first to see available time slots.');
    }
    List<int> availableHours = List.generate(16, (index) => 7 + index); // 7 AM to 10 PM (22)

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time Slot(s)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.0,
          ),
          itemCount: availableHours.length,
          itemBuilder: (context, index) {
            final hour = availableHours[index];
            final isSelected = selectedHours.contains(hour);
            final price = (hour >= 7 && hour < 17)
                ? selectedField!.morningPrice
                : selectedField!.afternoonPrice;
            return GestureDetector(
              onTap: () => _toggleHourSelection(hour),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? kPrimaryColor : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: isSelected ? kPrimaryColor : Colors.grey.shade400),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${hour.toString().padLeft(2, '0')}:00',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp${NumberFormat('#,###').format(price)}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTotalPrice() {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.all(color: kPrimaryColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total Price:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'Rp${NumberFormat('#,###').format(_calculateTotalPrice())}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return ElevatedButton(
      onPressed: () => _handleBooking(),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        "Book Now",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _handleBooking() async {
    if (selectedHours.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one time slot."),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (selectedField == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a field."),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final bookingMessage = "Halo, saya ingin booking ${selectedField!.name} "
        "di ${widget.venue.name} tanggal ${DateFormat('dd MMMM yyyy').format(selectedDate)} "
        "untuk jam ${selectedHours.map((h) => '${h.toString().padLeft(2, '0')}:00').join(', ')}. "
        "Total harga: Rp${NumberFormat('#,###').format(_calculateTotalPrice())}.";

    // Store booking data in Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': user.uid,
        'venueId': widget.venue.id,
        'venueName': widget.venue.name,
        'fieldName': selectedField!.name,
        'bookingDate': Timestamp.fromDate(selectedDate),
        'bookedHours': selectedHours,
        'totalPrice': _calculateTotalPrice(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    final whatsappUrl =
        "https://wa.me/${widget.venue.whatsappNumber}?text=${Uri.encodeComponent(bookingMessage)}";

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }
}