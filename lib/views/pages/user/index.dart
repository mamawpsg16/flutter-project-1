import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/user_view_model.dart';
import 'add.dart';
import 'edit.dart';
import 'dart:io';
import '../../../models/user.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Helper method to build the correct image widget
  ImageProvider _getProfileImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage('assets/images/default_profile.png');
    }

    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      final file = File(imagePath);
      if (file.existsSync()) {
        return FileImage(file);
      } else {
        print('Image file not found: $imagePath');
        return const AssetImage('assets/images/default_profile.png');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    // Use Future.microtask to schedule the loadUsers call after the current build is complete
    Future.microtask(() {
      if (mounted) {
        Provider.of<UserViewModel>(context, listen: false).loadUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userVM = Provider.of<UserViewModel>(context);
    final colorScheme = Theme.of(context).colorScheme;

    // Filter users based on search query
    final filteredUsers = userVM.users.where((user) {
      final name = user.email.toLowerCase();
      final role = user.role.toLowerCase();
      return name.contains(_searchQuery) || role.contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        title: Container(
          height: 50, // 👈 Adjust height to your preference
          alignment: Alignment.center,
          child: TextField(
            controller: _searchController,
            cursorColor: colorScheme.onPrimary,
            style: TextStyle(color: colorScheme.onPrimary),
            decoration: InputDecoration(
              hintText: 'Search user...',
              hintStyle: TextStyle(color: colorScheme.onPrimary.withOpacity(0.7)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: colorScheme.onPrimary.withOpacity(0.1),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12), // 👈 Tight vertical padding
              prefixIcon: Icon(
                Icons.search,
                color: colorScheme.onPrimary.withOpacity(0.7),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase();
              });
            },
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withOpacity(0.3),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: filteredUsers.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_alt_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No users found",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Try a different search",
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return UserCard(
                    user: user,
                    getProfileImage: _getProfileImage,
                  );
                },
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddUserView()),
          );
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final User user;
  final ImageProvider Function(String?) getProfileImage;

  const UserCard({
    super.key,
    required this.user,
    required this.getProfileImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditUserView(user: user)),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.black38,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: _ProfileImage(user: user, getProfileImage: getProfileImage),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _UserDetails(user: user),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _ProfileImage extends StatelessWidget {
  final dynamic user;
  final ImageProvider Function(String?) getProfileImage;

  const _ProfileImage({
    required this.user,
    required this.getProfileImage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Center(
        child: Hero(
          tag: 'user-${user.id}',
          child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: getProfileImage(user.profileImage),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserDetails extends StatelessWidget {
  final dynamic user;

  const _UserDetails({required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                user.email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              user.isActive ? Icons.check_circle : Icons.cancel,
              color: user.isActive ? Colors.green : Colors.red,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.secondary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            user.role,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.secondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
