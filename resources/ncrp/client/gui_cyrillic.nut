addEventHandler("onTranslate", function (key) {
  local phrases = {
    rotateCamera = "����� ��������� ���������, ������� Shift � �������� ����.",
    newName = "���������� ����� ���. ���� ��������� ����� ���������."
  }
  callEvent("onTranslateReturn", key, phrases[key]);
});

