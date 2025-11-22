import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const PinterestCloneApp());
}

/// ROOT APP
class PinterestCloneApp extends StatelessWidget {
  const PinterestCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..loadMockData(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Flutter Pinterest Clone',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.red,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainScaffold(),
          );
        },
      ),
    );
  }
}

/// MODELS

class Pin {
  final String id;
  final String imageUrl;
  final String title;
  final String category;
  final String author;
  int likes;
  bool isLiked;
  final List<String> comments;

  Pin({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.author,
    this.likes = 0,
    this.isLiked = false,
    List<String>? comments,
  }) : comments = comments ?? [];
}

class Board {
  final String id;
  final String name;
  final String description;
  final List<String> pinIds;

  Board({
    required this.id,
    required this.name,
    required this.description,
    List<String>? pinIds,
  }) : pinIds = pinIds ?? [];
}

class MessageThread {
  final String id;
  final String name;
  final List<String> messages;

  MessageThread({
    required this.id,
    required this.name,
    List<String>? messages,
  }) : messages = messages ?? [];
}

/// APP STATE (mock backend)

class AppState extends ChangeNotifier {
  bool isDarkMode = false;
  bool isLoggedIn = true; // TODO: connect to real auth later

  final List<Pin> _pins = [];
  final List<Board> _boards = []; // ✅ FIXED HERE
  final List<MessageThread> _threads = [];

  List<Pin> get pins => List.unmodifiable(_pins);
  List<Board> get boards => List.unmodifiable(_boards);
  List<MessageThread> get threads => List.unmodifiable(_threads);

  String get currentUserName => isLoggedIn ? 'SmartNest User' : 'Guest';

  void loadMockData() {
    if (_pins.isNotEmpty) return;

    // Mock pins (using Picsum)
    _pins.addAll([
      Pin(
        id: '1',
        imageUrl: 'https://picsum.photos/400/600?random=1',
        title: 'Cozy reading nook',
        category: 'Home Decor',
        author: 'SmartNest',
        likes: 21,
      ),
      Pin(
        id: '2',
        imageUrl: 'https://picsum.photos/400/600?random=2',
        title: 'Minimal study desk setup',
        category: 'Workspace',
        author: 'Fatima',
        likes: 15,
      ),
      Pin(
        id: '3',
        imageUrl: 'https://picsum.photos/400/600?random=3',
        title: 'Pink crochet dinosaur',
        category: 'Crafts',
        author: 'Soha',
        likes: 45,
      ),
      Pin(
        id: '4',
        imageUrl: 'https://picsum.photos/400/600?random=4',
        title: 'Healthy lunchbox idea',
        category: 'Food',
        author: 'Saleh',
        likes: 9,
      ),
      Pin(
        id: '5',
        imageUrl: 'https://picsum.photos/400/600?random=5',
        title: 'Kids study corner',
        category: 'Homeschool',
        author: 'SmartNest',
        likes: 33,
      ),
      Pin(
        id: '6',
        imageUrl: 'https://picsum.photos/400/600?random=6',
        title: 'Nature journal spread',
        category: 'Journaling',
        author: 'Zain',
        likes: 18,
      ),
    ]);

    // Mock boards
    _boards.addAll([
      Board(
        id: 'b1',
        name: 'Homeschool Ideas',
        description: 'Learning spaces, activities & routines.',
        pinIds: ['1', '5', '6'],
      ),
      Board(
        id: 'b2',
        name: 'Crafts & Crochet',
        description: 'Cute amigurumi and paper crafts.',
        pinIds: ['3'],
      ),
      Board(
        id: 'b3',
        name: 'Healthy Food',
        description: 'Lunchbox & meal inspiration.',
        pinIds: ['4'],
      ),
    ]);

    // Mock message threads
    _threads.addAll([
      MessageThread(
        id: 't1',
        name: 'Soha',
        messages: [
          'Can you send me the crochet dino pattern?',
          'Also, save some pins for our next project!',
        ],
      ),
      MessageThread(
        id: 't2',
        name: 'Homeschool Moms Group',
        messages: [
          'Sharing today’s board: Calm Morning Routines 🌿',
          'Loved your SmartNest pin!',
        ],
      ),
    ]);

    notifyListeners();
  }

  Pin getPinById(String id) {
    return _pins.firstWhere((p) => p.id == id);
  }

  Board getBoardById(String id) {
    return _boards.firstWhere((b) => b.id == id);
  }

  void toggleLike(String pinId) {
    final pin = getPinById(pinId);
    pin.isLiked = !pin.isLiked;
    pin.likes += pin.isLiked ? 1 : -1;
    notifyListeners();
  }

  void addComment(String pinId, String comment) {
    if (comment.trim().isEmpty) return;
    final pin = getPinById(pinId);
    pin.comments.add(comment.trim());
    notifyListeners();
  }

  void savePinToBoard(String pinId, String boardId) {
    final board = getBoardById(boardId);
    if (!board.pinIds.contains(pinId)) {
      board.pinIds.add(pinId);
      notifyListeners();
    }
  }

  List<Pin> searchPins(String query) {
    if (query.trim().isEmpty) return pins;
    final lower = query.toLowerCase();
    return pins
        .where((p) =>
            p.title.toLowerCase().contains(lower) ||
            p.category.toLowerCase().contains(lower) ||
            p.author.toLowerCase().contains(lower))
        .toList();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  // mock "login/logout"
  void toggleLogin() {
    isLoggedIn = !isLoggedIn;
    notifyListeners();
  }

  void addMessage(String threadId, String text) {
    if (text.trim().isEmpty) return;
    final thread = _threads.firstWhere((t) => t.id == threadId);
    thread.messages.add(text.trim());
    notifyListeners();
  }

  /// NEW: Add a pin (local only)
  void addPin({
    required String imageUrl,
    required String title,
    required String category,
    String? author,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newPin = Pin(
      id: id,
      imageUrl: imageUrl,
      title: title,
      category: category,
      author:
          author?.trim().isNotEmpty == true ? author!.trim() : currentUserName,
      likes: 0,
      isLiked: false,
      comments: [],
    );
    _pins.insert(0, newPin); // add at top of feed
    notifyListeners();
  }
}

/// MAIN SCAFFOLD WITH BOTTOM NAV

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeFeedScreen(),
    SearchScreen(),
    BoardsScreen(),
    ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Boards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// HOME FEED

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final pins = appState.pins;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pinterest Clone'),
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MessagesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: pins.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          final pin = pins[index];
          return PinCard(pin: pin);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CreatePinScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// PIN CARD (USED IN GRIDS)

class PinCard extends StatelessWidget {
  final Pin pin;
  const PinCard({super.key, required this.pin});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PinDetailScreen(pinId: pin.id),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'pin_${pin.id}',
                child: Image.network(
                  pin.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                pin.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                children: [
                  Text(
                    pin.category,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey),
                  ),
                  const Spacer(),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    iconSize: 20,
                    onPressed: () {
                      appState.toggleLike(pin.id);
                    },
                    icon: Icon(
                      pin.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: pin.isLiked ? Colors.red : null,
                    ),
                  ),
                  Text(pin.likes.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// PIN DETAIL

class PinDetailScreen extends StatefulWidget {
  final String pinId;
  const PinDetailScreen({super.key, required this.pinId});

  @override
  State<PinDetailScreen> createState() => _PinDetailScreenState();
}

class _PinDetailScreenState extends State<PinDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final pin = appState.getPinById(widget.pinId);
    final boards = appState.boards;

    return Scaffold(
      appBar: AppBar(
        title: Text(pin.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // TODO: integrate system share or custom share
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('TODO: Implement share'),
                ),
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Hero(
            tag: 'pin_${pin.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                pin.imageUrl,
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  height: 300,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pin.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            '${pin.category} • by ${pin.author}',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  pin.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: pin.isLiked ? Colors.red : null,
                ),
                onPressed: () {
                  appState.toggleLike(pin.id);
                },
              ),
              Text('${pin.likes} likes'),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    builder: (_) {
                      return ListView(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Save to board',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          for (final board in boards)
                            ListTile(
                              title: Text(board.name),
                              subtitle: Text(board.description),
                              trailing: board.pinIds.contains(pin.id)
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              onTap: () {
                                appState.savePinToBoard(pin.id, board.id);
                                Navigator.of(context).pop();
                              },
                            )
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.push_pin_outlined),
                label: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Comments',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (pin.comments.isEmpty)
            const Text(
              'No comments yet. Be the first to comment!',
              style: TextStyle(color: Colors.grey),
            )
          else
            ...pin.comments.map(
              (c) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(c),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  appState.addComment(pin.id, _commentController.text);
                  _commentController.clear();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// SEARCH / EXPLORE

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final results = appState.searchPins(_query);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by title, category, or author',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                final pin = results[index];
                return PinCard(pin: pin);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// BOARDS

class BoardsScreen extends StatelessWidget {
  const BoardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final boards = context.watch<AppState>().boards;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boards'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: boards.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final board = boards[index];
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: Theme.of(context).colorScheme.surfaceVariant,
            title: Text(board.name),
            subtitle: Text(board.description),
            trailing: Text('${board.pinIds.length} pins'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BoardDetailScreen(boardId: board.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: implement "create board"
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('TODO: Implement create board feature'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BoardDetailScreen extends StatelessWidget {
  final String boardId;
  const BoardDetailScreen({super.key, required this.boardId});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final board = appState.getBoardById(boardId);
    final pins = board.pinIds.map((id) => appState.getPinById(id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(board.name),
      ),
      body: pins.isEmpty
          ? const Center(
              child: Text(
                'No pins yet.\nSave some pins to this board!',
                textAlign: TextAlign.center,
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: pins.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                final pin = pins[index];
                return PinCard(pin: pin);
              },
            ),
    );
  }
}

/// PROFILE + SETTINGS

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  appState.isLoggedIn ? 'SmartNest User' : 'Guest',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: () {
                  appState.toggleLogin();
                },
                child: Text(appState.isLoggedIn ? 'Log out' : 'Log in'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: appState.isDarkMode,
            onChanged: (_) => appState.toggleTheme(),
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.message_outlined),
            title: const Text('Messages'),
            subtitle: const Text('View your message threads'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MessagesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('TODO: Connect push notification system'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'TODO: Implement real push notifications with backend'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// MESSAGES (DM DEMO)

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final threads = context.watch<AppState>().threads;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: threads.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final thread = threads[index];
          final last = thread.messages.isNotEmpty
              ? thread.messages.last
              : 'No messages yet';
          return ListTile(
            leading: CircleAvatar(
              child: Text(
                thread.name.isNotEmpty ? thread.name[0].toUpperCase() : '?',
              ),
            ),
            title: Text(thread.name),
            subtitle: Text(
              last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatScreen(threadId: thread.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String threadId;
  const ChatScreen({super.key, required this.threadId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final thread = appState.threads.firstWhere((t) => t.id == widget.threadId);

    return Scaffold(
      appBar: AppBar(
        title: Text(thread.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: thread.messages.length,
              itemBuilder: (context, index) {
                final msg = thread.messages[index];
                final isMe = index.isOdd; // just mock
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    appState.addMessage(thread.id, _msgController.text);
                    _msgController.clear();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// NEW SCREEN: CREATE PIN

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  void dispose() {
    _imageUrlController.dispose();
    _titleController.dispose();
    _categoryController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _savePin() {
    final imageUrl = _imageUrlController.text.trim();
    final title = _titleController.text.trim();
    final category = _categoryController.text.trim();
    final author = _authorController.text.trim();

    if (imageUrl.isEmpty || title.isEmpty || category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill image URL, title and category.'),
        ),
      );
      return;
    }

    final appState = context.read<AppState>();
    appState.addPin(
      imageUrl: imageUrl,
      title: title,
      category: category,
      author: author.isEmpty ? null : author,
    );

    Navigator.of(context).pop(); // go back to home feed
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Pin'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'Image URL',
              hintText: 'https://example.com/my-image.jpg',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _categoryController,
            decoration: const InputDecoration(
              labelText: 'Category',
              hintText: 'e.g. Crafts, Food, Homeschool',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _authorController,
            decoration: InputDecoration(
              labelText: 'Author (optional)',
              hintText: 'Defaults to ${appState.currentUserName}',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _savePin,
            icon: const Icon(Icons.push_pin_outlined),
            label: const Text('Save Pin'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tip: For testing, you can use any online image link, '
            'for example: https://picsum.photos/400/600?random=10',
          ),
        ],
      ),
    );
  }
}
