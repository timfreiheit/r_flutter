T? safeCast<T>(dynamic obj) {
  if (obj == null) {
    return null;
  }
  return (obj is T) ? obj : null;
}
