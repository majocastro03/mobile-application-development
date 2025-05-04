import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/send_message.dart';

// Vista de Perfil de Usuario
class UserProfileView extends StatelessWidget {
  final User user;

  const UserProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto de perfil
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: 64,
            ),
            const SizedBox(height: 24),

            // Nombre completo
            Text(
              user.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Información de contacto
            _buildInfoCard(context),
            const SizedBox(height: 24),
            // Botón para enviar mensaje
            ElevatedButton.icon(
              onPressed: () => _showSendMessageDialog(context),
              icon: const Icon(Icons.message),
              label: const Text('Enviar Mensaje'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.email, 'Correo Electrónico', user.email),
            const Divider(height: 24),
            _buildInfoRow(Icons.phone, 'Número Telefónico', user.phoneNumber),
            const Divider(height: 24),
            _buildInfoRow(Icons.work, 'Cargo', user.position),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSendMessageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SendMessageModal(user: user),
    );
  }
}
