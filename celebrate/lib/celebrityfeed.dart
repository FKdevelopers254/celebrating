import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import './models/celebrity.dart';
import './services/celebrity_service.dart';
import './services/auth_service.dart';
import './widgets/celebrity_card.dart';
import './widgets/search_bar.dart' as custom_search;

class CelebrityFeed extends StatefulWidget {
  const CelebrityFeed({super.key});

  @override
  State<CelebrityFeed> createState() => _CelebrityFeedState();
}

class _CelebrityFeedState extends State<CelebrityFeed> {
  late CelebrityService _celebrityService;
  List<Celebrity> _celebrities = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    _celebrityService = CelebrityService(authToken: authService.token);
    _loadCelebrities();
  }

  Future<void> _loadCelebrities() async {
    setState(() => _isLoading = true);
    try {
      final celebrities = _searchQuery.isEmpty
          ? await _celebrityService.getAllCelebrities()
          : await _celebrityService.searchCelebrities(_searchQuery);
      setState(() {
        _celebrities = celebrities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading celebrities: $e')),
        );
      }
    }
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query);
    _loadCelebrities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Celebrity Feed'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: custom_search.SearchBar(
              controller: _searchController,
              onSearch: _onSearch,
              hintText: 'Search celebrities...',
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadCelebrities,
              child: _celebrities.isEmpty
                  ? Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'No celebrities found'
                            : 'No results for "$_searchQuery"',
                      ),
                    )
                  : ListView.builder(
                      itemCount: _celebrities.length,
                      itemBuilder: (context, index) {
                        final celebrity = _celebrities[index];
                        return CelebrityCard(celebrity: celebrity);
                      },
                    ),
            ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class CelebrityCard extends StatelessWidget {
  final Celebrity celebrity;

  const CelebrityCard({
    super.key,
    required this.celebrity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to celebrity detail page
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 40,
                    child: Text(
                      celebrity.stageName[0].toUpperCase(),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Celebrity Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          celebrity.stageName,
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          celebrity.fullName,
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          celebrity.professions.join(', '),
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Career Highlights
              if (celebrity.majorAchievements.isNotEmpty) ...[
                Text(
                  'Career Highlights',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  celebrity.majorAchievements.first,
                  style: GoogleFonts.lato(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 16),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(
                      'Projects', celebrity.notableProjects.length.toString()),
                  _buildStat('Collaborations',
                      celebrity.collaborations.length.toString()),
                  _buildStat('Net Worth', celebrity.netWorth),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
