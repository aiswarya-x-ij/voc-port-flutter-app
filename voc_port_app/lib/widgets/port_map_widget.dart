import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

// ============================================================
// VOC PORT MAP WIDGET - Fixed version
// Uses a single SizedBox.expand + CustomPainter to avoid
// LayoutBuilder-inside-Stack constraint issues on Flutter Web
// ============================================================

class PortMapWidget extends StatelessWidget {
  const PortMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFB3E5FC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.vocBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CustomPaint(
          painter: _VocPortMapPainter(),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _VocPortMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Ocean background ──
    _drawOcean(canvas, size);

    // ── Port land ──
    _drawLand(canvas, size);

    // ── Roads ──
    _drawRoads(canvas, w, h);

    // ── Area zones ──
    _drawZone(canvas, w * 0.10, h * 0.03, w * 0.60, h * 0.22,
        const Color(0xFF90CAF9).withOpacity(0.5), 'BERTH OPERATIONAL ZONE');
    _drawZone(canvas, w * 0.10, h * 0.44, w * 0.34, h * 0.62,
        const Color(0xFFA5D6A7).withOpacity(0.5), 'NCB ZONE');
    _drawZone(canvas, w * 0.48, h * 0.36, w * 0.70, h * 0.58,
        const Color(0xFFFFCC80).withOpacity(0.5), 'CONTAINER TERMINAL');

    // ── Berth labels ──
    _drawAreaChip(canvas, w * 0.13, h * 0.06, 'VOC I', const Color(0xFF1565C0));
    _drawAreaChip(canvas, w * 0.21, h * 0.06, 'VOC II', const Color(0xFF1565C0));
    _drawAreaChip(canvas, w * 0.30, h * 0.06, 'VOC III', const Color(0xFF1565C0));
    _drawAreaChip(canvas, w * 0.40, h * 0.06, 'VOC IV', const Color(0xFF1565C0));
    _drawAreaChip(canvas, w * 0.51, h * 0.06, 'Berth V', const Color(0xFF0277BD));
    _drawAreaChip(canvas, w * 0.61, h * 0.06, 'Berth VI', const Color(0xFF0277BD));
    _drawAreaChip(canvas, w * 0.70, h * 0.06, 'Berth VII', const Color(0xFF0277BD));

    // ── Jetty labels ──
    _drawAreaChip(canvas, w * 0.26, h * 0.28, 'Coal Jetty I', const Color(0xFF4A148C));
    _drawAreaChip(canvas, w * 0.40, h * 0.28, 'Coal Jetty II', const Color(0xFF4A148C));
    _drawAreaChip(canvas, w * 0.56, h * 0.28, 'Oil Jetty', const Color(0xFF880E4F));

    // ── NCB labels ──
    _drawAreaChip(canvas, w * 0.12, h * 0.50, 'NCB I', const Color(0xFF1B5E20));
    _drawAreaChip(canvas, w * 0.22, h * 0.50, 'NCB II', const Color(0xFF1B5E20));
    _drawAreaChip(canvas, w * 0.32, h * 0.50, 'NCB III', const Color(0xFF1B5E20));

    // ── Other areas ──
    _drawAreaChip(canvas, w * 0.50, h * 0.42, 'Container\nTerminal', const Color(0xFFE65100));
    _drawAreaChip(canvas, w * 0.44, h * 0.65, 'Stack Yard', const Color(0xFF4E342E));
    _drawAreaChip(canvas, w * 0.10, h * 0.70, 'Open Storage Yard', const Color(0xFF37474F));
    _drawAreaChip(canvas, w * 0.72, h * 0.14, 'Eastern Arm', const Color(0xFF006064));
    _drawAreaChip(canvas, w * 0.70, h * 0.50, 'Coastal Berth', const Color(0xFF0277BD));
    _drawAreaChip(canvas, w * 0.24, h * 0.72, 'Transit Shed', const Color(0xFF5D4037));
    _drawAreaChip(canvas, w * 0.55, h * 0.72, 'Warehouse Area', const Color(0xFF455A64));

    // ── Gate markers ──
    _drawGate(canvas, w * 0.06, h * 0.18, 'Red Gate', Colors.red);
    _drawGate(canvas, w * 0.06, h * 0.48, 'Blue Gate', Colors.blue);
    _drawGate(canvas, w * 0.06, h * 0.85, 'Green Gate', Colors.green);
    _drawGate(canvas, w * 0.14, h * 0.76, 'Yellow Gate', Colors.amber.shade700);

    // ── Truck markers (mock) ──
    _drawTruck(canvas, w * 0.25, h * 0.15, const Color(0xFF2E7D32)); // en route
    _drawTruck(canvas, w * 0.48, h * 0.20, Colors.blue);             // at destination
    _drawTruck(canvas, w * 0.30, h * 0.38, const Color(0xFF2E7D32)); // en route
    _drawTruck(canvas, w * 0.20, h * 0.52, const Color(0xFFF57C00)); // loading
    _drawTruck(canvas, w * 0.57, h * 0.50, const Color(0xFFD32F2F)); // alert
    _drawTruck(canvas, w * 0.65, h * 0.30, const Color(0xFF2E7D32)); // en route
    _drawTruck(canvas, w * 0.38, h * 0.68, const Color(0xFFF57C00)); // loading

    // ── Title overlay ──
    _drawTitleBadge(canvas, w, h);

    // ── Legend ──
    _drawLegend(canvas, w, h);
  }

  // ── Ocean ──
  void _drawOcean(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFB3E5FC);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final wavePaint = Paint()
      ..color = const Color(0xFF81D4FA).withOpacity(0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 10; i++) {
      final y = size.height * (0.08 + i * 0.09);
      final path = Path();
      path.moveTo(0, y);
      for (double x = 0; x < size.width; x += 40) {
        path.quadraticBezierTo(x + 20, y - 5, x + 40, y);
      }
      canvas.drawPath(path, wavePaint);
    }
  }

  // ── Land ──
  void _drawLand(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final landPaint = Paint()..color = const Color(0xFFE8D5A3);
    final portPath = Path();
    portPath.moveTo(w * 0.04, h * 0.98);
    portPath.lineTo(w * 0.04, h * 0.14);
    portPath.lineTo(w * 0.12, h * 0.02);
    portPath.lineTo(w * 0.72, h * 0.02);
    portPath.lineTo(w * 0.87, h * 0.12);
    portPath.lineTo(w * 0.90, h * 0.32);
    portPath.lineTo(w * 0.82, h * 0.62);
    portPath.lineTo(w * 0.72, h * 0.98);
    portPath.close();
    canvas.drawPath(portPath, landPaint);

    // Inner road network texture
    final roadBasePaint = Paint()
      ..color = const Color(0xFFD4C49A)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(w * 0.04, h * 0.60, w * 0.68, h * 0.06), roadBasePaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.08, h * 0.14, w * 0.04, h * 0.84), roadBasePaint);
  }

  // ── Zone rectangle with label ──
  void _drawZone(Canvas canvas, double x1, double y1, double x2, double y2,
      Color color, String label) {
    final zonePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final rrect = RRect.fromRectAndRadius(
        Rect.fromLTRB(x1, y1, x2, y2), const Radius.circular(6));
    canvas.drawRRect(rrect, zonePaint);
  }

  // ── Roads ──
  void _drawRoads(Canvas canvas, double w, double h) {
    final roadPaint = Paint()
      ..color = const Color(0xFF90A4AE).withOpacity(0.6)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Main horizontal road
    canvas.drawLine(Offset(w * 0.08, h * 0.62), Offset(w * 0.78, h * 0.62), roadPaint);
    // South vertical road
    canvas.drawLine(Offset(w * 0.10, h * 0.16), Offset(w * 0.10, h * 0.92), roadPaint);
    // Berth access road
    canvas.drawLine(Offset(w * 0.10, h * 0.22), Offset(w * 0.80, h * 0.22), roadPaint);
    // NCB access
    canvas.drawLine(Offset(w * 0.10, h * 0.56), Offset(w * 0.44, h * 0.56), roadPaint);
    // Container terminal access
    canvas.drawLine(Offset(w * 0.50, h * 0.22), Offset(w * 0.50, h * 0.62), roadPaint);
  }

  // ── Area chip (colored label box) ──
  void _drawAreaChip(Canvas canvas, double x, double y, String label, Color color) {
    final lines = label.split('\n');
    const fontSize = 9.0;
    const padH = 5.0;
    const padV = 3.0;

    // Measure longest line
    double maxW = 0;
    for (final line in lines) {
      final tp = TextPainter(
        text: TextSpan(text: line, style: const TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600)),
        textDirection: TextDirection.ltr,
      )..layout();
      if (tp.width > maxW) maxW = tp.width;
    }

    final boxW = maxW + padH * 2;
    final boxH = (fontSize + 2) * lines.length + padV * 2;

    final bgPaint = Paint()..color = color.withOpacity(0.88);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(x, y, boxW, boxH), const Radius.circular(3)),
      bgPaint,
    );

    for (int i = 0; i < lines.length; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: lines[i],
          style: const TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x + padH, y + padV + i * (fontSize + 2)));
    }
  }

  // ── Gate dot + label ──
  void _drawGate(Canvas canvas, double cx, double cy, String label, Color color) {
    final dotPaint = Paint()..color = color;
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(cx, cy), 7, dotPaint);
    canvas.drawCircle(Offset(cx, cy), 7, borderPaint);

    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(fontSize: 8, color: color, fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx + 10, cy - 4));
  }

  // ── Truck marker ──
  void _drawTruck(Canvas canvas, double cx, double cy, Color color) {
    final paint = Paint()..color = color;
    final border = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(Offset(cx, cy), 9, paint);
    canvas.drawCircle(Offset(cx, cy), 9, border);

    // Tiny truck icon (simplified rectangle)
    final truckPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 5, cy - 3, 10, 6), const Radius.circular(1)),
      truckPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 5, cy - 6, 5, 3), const Radius.circular(1)),
      truckPaint,
    );
  }

  // ── Title badge ──
  void _drawTitleBadge(Canvas canvas, double w, double h) {
    final bgPaint = Paint()..color = const Color(0xFF1A237E).withOpacity(0.85);
    const text = 'V.O.C. Port Authority — Live Port Map';
    final tp = TextPainter(
      text: const TextSpan(
        text: text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final boxW = tp.width + 20;
    const boxH = 24.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(10, 10, boxW, boxH), const Radius.circular(5)),
      bgPaint,
    );
    tp.paint(canvas, const Offset(20, 15));
  }

  // ── Legend ──
  void _drawLegend(Canvas canvas, double w, double h) {
    final bgPaint = Paint()..color = Colors.white.withOpacity(0.92);
    final borderPaint = Paint()
      ..color = const Color(0xFFE3E8F7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const legendW = 130.0;
    const legendH = 72.0;
    final lx = w - legendW - 10;
    const ly = 10.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(lx, ly, legendW, legendH), const Radius.circular(6)),
      bgPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(lx, ly, legendW, legendH), const Radius.circular(6)),
      borderPaint,
    );

    final items = [
      ('En Route', const Color(0xFF2E7D32)),
      ('At Destination', Colors.blue),
      ('Loading/Unloading', const Color(0xFFF57C00)),
      ('Alert', const Color(0xFFD32F2F)),
    ];

    for (int i = 0; i < items.length; i++) {
      final dotPaint = Paint()..color = items[i].$2;
      final dx = lx + 12.0;
      final dy = ly + 14.0 + i * 16.0;

      canvas.drawCircle(Offset(dx, dy), 5, dotPaint);

      final tp = TextPainter(
        text: TextSpan(
          text: items[i].$1,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Color(0xFF1A1A2E)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(dx + 10, dy - 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
