import 'package:flutter/material.dart';

import 'app_colors.dart';

class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.high,
    required this.onHigh,
    required this.highContainer,
    required this.onHighContainer,
    required this.done,
    required this.onDone,
    required this.doneContainer,
    required this.onDoneContainer,
    required this.accent,
    required this.onAccent,
    required this.accentContainer,
    required this.onAccentContainer,
  });

  final Color high;
  final Color onHigh;
  final Color highContainer;
  final Color onHighContainer;
  final Color done;
  final Color onDone;
  final Color doneContainer;
  final Color onDoneContainer;
  final Color accent;
  final Color onAccent;
  final Color accentContainer;
  final Color onAccentContainer;

  static const light = StatusColors(
    high: AppColors.statusHigh,
    onHigh: AppColors.onStatusHigh,
    highContainer: AppColors.statusHighContainer,
    onHighContainer: AppColors.onStatusHighContainer,
    done: AppColors.statusDone,
    onDone: AppColors.onStatusDone,
    doneContainer: AppColors.statusDoneContainer,
    onDoneContainer: AppColors.onStatusDoneContainer,
    accent: AppColors.accent,
    onAccent: AppColors.onAccent,
    accentContainer: AppColors.accentContainer,
    onAccentContainer: AppColors.onAccentContainer,
  );

  static const dark = StatusColors(
    high: AppColors.statusHighLight,
    onHigh: AppColors.onStatusHighContainer,
    highContainer: Color(0xFF6B3000),
    onHighContainer: AppColors.statusHighContainer,
    done: AppColors.statusDoneLight,
    onDone: AppColors.onStatusDoneContainer,
    doneContainer: Color(0xFF005313),
    onDoneContainer: AppColors.statusDoneContainer,
    accent: AppColors.accentLight,
    onAccent: AppColors.onAccentContainer,
    accentContainer: Color(0xFF004D55),
    onAccentContainer: AppColors.accentContainer,
  );

  @override
  StatusColors copyWith({
    Color? high,
    Color? onHigh,
    Color? highContainer,
    Color? onHighContainer,
    Color? done,
    Color? onDone,
    Color? doneContainer,
    Color? onDoneContainer,
    Color? accent,
    Color? onAccent,
    Color? accentContainer,
    Color? onAccentContainer,
  }) {
    return StatusColors(
      high: high ?? this.high,
      onHigh: onHigh ?? this.onHigh,
      highContainer: highContainer ?? this.highContainer,
      onHighContainer: onHighContainer ?? this.onHighContainer,
      done: done ?? this.done,
      onDone: onDone ?? this.onDone,
      doneContainer: doneContainer ?? this.doneContainer,
      onDoneContainer: onDoneContainer ?? this.onDoneContainer,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentContainer: accentContainer ?? this.accentContainer,
      onAccentContainer: onAccentContainer ?? this.onAccentContainer,
    );
  }

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other is! StatusColors) return this;
    return StatusColors(
      high: Color.lerp(high, other.high, t)!,
      onHigh: Color.lerp(onHigh, other.onHigh, t)!,
      highContainer: Color.lerp(highContainer, other.highContainer, t)!,
      onHighContainer: Color.lerp(onHighContainer, other.onHighContainer, t)!,
      done: Color.lerp(done, other.done, t)!,
      onDone: Color.lerp(onDone, other.onDone, t)!,
      doneContainer: Color.lerp(doneContainer, other.doneContainer, t)!,
      onDoneContainer: Color.lerp(onDoneContainer, other.onDoneContainer, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      accentContainer: Color.lerp(accentContainer, other.accentContainer, t)!,
      onAccentContainer: Color.lerp(onAccentContainer, other.onAccentContainer, t)!,
    );
  }
}
