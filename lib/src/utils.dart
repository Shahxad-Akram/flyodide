List<dynamic> parseNumpyReturn(dynamic numpyReturn) {
  if (numpyReturn is Map) {
    return numpyReturn.values.toList().cast<double>();
  } else if (numpyReturn is List) {
    return numpyReturn.map((item) => parseNumpyReturn(item)).toList();
  } else {
    return numpyReturn;
  }
}
