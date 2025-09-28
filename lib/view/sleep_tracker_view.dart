import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/sleep_viewmodel.dart';

class SleepTrackerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SleepViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: AnimatedContainer(
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  viewModel.primaryColor,
                  viewModel.secondaryColor,
                  viewModel.accentColor,
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  if (viewModel.isNightMode) _buildStarsBackground(),
                  
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildHeader(viewModel),
                          SizedBox(height: 30),
                          _buildSleepCircle(viewModel),
                          SizedBox(height: 40),
                          _buildNapTimer(viewModel),
                          SizedBox(height: 30),
                          _buildStatsGrid(viewModel),
                          SizedBox(height: 20),
                          _buildControlButtons(viewModel),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStarsBackground() {
    return CustomPaint(
      painter: StarsPainter(),
      size: Size.infinite,
    );
  }

  Widget _buildHeader(SleepViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.white, Colors.white70, Colors.white54],
              ).createShader(bounds),
              child: Text(
                '¡Buenas ${viewModel.isNightMode ? 'noches' : 'días'}!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            FadeTransition(
              opacity: AlwaysStoppedAnimation(0.8),
              child: Text(
                'Fase: ${viewModel.currentSleepData.sleepPhase}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
        Hero(
          tag: 'night_mode_button',
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  onPressed: viewModel.toggleNightMode,
                  icon: Icon(
                    viewModel.isNightMode ? Icons.wb_sunny : Icons.nightlight_round,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSleepCircle(SleepViewModel viewModel) {
    return Hero(
      tag: 'sleep_circle',
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: 250,
        height: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              painter: WavesPainter(viewModel.sleepProgress),
              size: Size(250, 250),
            ),
            
            ClipRRect(
              borderRadius: BorderRadius.circular(125),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(
                    color: viewModel.isNightMode ? Colors.purpleAccent : Colors.white,
                    width: 8,
                  ),
                ),
              ),
            ),
            
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white, Colors.white60],
                  ).createShader(bounds),
                  child: Text(
                    '${viewModel.currentSleepData.sleepHours.toStringAsFixed(1)}h',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.7),
                  child: Text(
                    'Horas de sueño',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Text(
                      'Score: ${viewModel.currentSleepData.sleepScore}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNapTimer(SleepViewModel viewModel) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white, Colors.white70],
                  ).createShader(bounds),
                  child: Text(
                    'Temporizador de Siesta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.7),
                  child: Icon(
                    Icons.timer,
                    color: Colors.white70,
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            if (viewModel.isNapping) ...[
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.white, Colors.white60],
                ).createShader(bounds),
                child: Text(
                  viewModel.formattedNapTime,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Container(
                  height: 6,
                  width: double.infinity,
                  color: Colors.white.withOpacity(0.2),
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: viewModel.isNightMode ? Colors.purpleAccent : Colors.white,
                    ),
                  ),
                ),
              ),
            ] else ...[
              Text(
                '20:00',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  fontFamily: 'monospace',
                ),
              ),
              SizedBox(height: 10),
              FadeTransition(
                opacity: AlwaysStoppedAnimation(0.7),
                child: Text(
                  'Duración recomendada',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(SleepViewModel viewModel) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Promedio de Sueño',
          '${viewModel.sleepStats.averageSleep}h',
          Icons.bedtime,
          viewModel.sleepStats.averageSleep / 10,
          viewModel,
        ),
        _buildStatCard(
          'Sueño Profundo',
          '${(viewModel.sleepStats.deepSleepPercent * 100).toInt()}%',
          Icons.nights_stay,
          viewModel.sleepStats.deepSleepPercent,
          viewModel,
        ),
        _buildStatCard(
          'Sueño REM',
          '${(viewModel.sleepStats.remSleepPercent * 100).toInt()}%',
          Icons.psychology,
          viewModel.sleepStats.remSleepPercent,
          viewModel,
        ),
        _buildStatCard(
          'Siestas Totales',
          '${viewModel.sleepStats.totalNaps}',
          Icons.snooze,
          viewModel.sleepStats.totalNaps / 50,
          viewModel,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, 
                       double progress, SleepViewModel viewModel) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FadeTransition(
                  opacity: AlwaysStoppedAnimation(0.7),
                  child: Icon(icon, color: Colors.white70, size: 24),
                ),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.8)],
                  ).createShader(bounds),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 4,
                width: double.infinity,
                color: Colors.white.withOpacity(0.2),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: double.infinity * progress.clamp(0.0, 1.0),
                  decoration: BoxDecoration(
                    color: viewModel.isNightMode ? Colors.purpleAccent : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons(SleepViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: Hero(
            tag: 'nap_button',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                child: ElevatedButton.icon(
                  onPressed: viewModel.isNapping ? viewModel.stopNap : viewModel.startNap,
                  icon: FadeTransition(
                    opacity: AlwaysStoppedAnimation(1.0),
                    child: Icon(
                      viewModel.isNapping ? Icons.stop : Icons.play_arrow,
                      color: viewModel.isNightMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  label: Text(
                    viewModel.isNapping ? 'Detener Siesta' : 'Iniciar Siesta',
                    style: TextStyle(
                      color: viewModel.isNightMode ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: viewModel.isNapping 
                        ? Colors.red.withOpacity(0.8)
                        : Colors.white.withOpacity(0.9),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Hero(
            tag: 'track_button',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ElevatedButton.icon(
                onPressed: viewModel.toggleTracking,
                icon: Icon(
                  viewModel.isTracking ? Icons.stop : Icons.track_changes,
                  color: viewModel.isNightMode ? Colors.white : Colors.black87,
                ),
                label: Text(
                  viewModel.isTracking ? 'Detener Track' : 'Iniciar Track',
                  style: TextStyle(
                    color: viewModel.isNightMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: viewModel.isTracking 
                      ? Colors.orange.withOpacity(0.8)
                      : Colors.white.withOpacity(0.9),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    for (int i = 0; i < 20; i++) {
      final x = (i * 37) % size.width;
      final y = (i * 73) % size.height;
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WavesPainter extends CustomPainter {
  final double progress;
  
  WavesPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    
    for (int i = 0; i < 3; i++) {
      final radius = 80 + i * 25;
      canvas.drawCircle(center, radius.toDouble(), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}