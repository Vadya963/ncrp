_local_data <- {};

function l(name, lang = 0) 
{
	if (!lang) lang = DEFAULT_LANGUAGE;
	return _local_data[lang][name];
}

function localize(lang, params) 
{
	_local_data[lang] <- {};
	foreach(name, param in params)
	{
		_local_data[lang][name] <- param;
	}
}

localize("ru", {
	message_yellow = "[����] ",
	message_red = "[������] ",
	message_green = "[�������] ",
	message_hint = "[���������] ",
	
	welcome_title = "����� ���������� �� ������.", 
	welcome_login1 = "��� ������� ���������������.",
	welcome_login2 = "������� � ���� � ������� /login <password>",
	welcome_register1 = "��� ������� �����������������.",
	welcome_register2 = "����������������� � ������� /register <password>",
	
	stats_begin = "���������� ",
	player_onafk = "�� ���� � ���.",
	player_ondeafk = "�� ��������� �� ���.",
	player_have = "� ��� ",
	have = " ����� ",
	player_cash = " ��������.",
	player_adminlevel = " ������� ��������������."
	player_facing = " ��������: ",
	
	err_nopassword = "�� �� ����� ������.",
	err_registered = "������ ������� ���������������, ���� �� ��� ����� � �������.",
	err_loginfail = "����� ��� ������ �������, ���� ������� � ������ ������� �����������������.",
	
	login_success = "�� ������� ����� � �������.",
	dont_logined = "�� �� ����� � �������.",
	register_success = "��� ������� ������� ���������������. ����������� /login <password>, ����� �����",
	reglogin_success = "�� ������� ������������������ � ������������� ����� � �������.",
	
	not_an_admin = "�� �� ��������� ���������������.",
	wrong_admin_level = "������� ���������� ��� ������ ������ ��������������.",
	
	vehicle = "������� ",
	not_in_vehicle = "�� ���������� ��� ������",
	vehicle_tuning_level = " ������� �������.",
	
	structure_menu = "���������� �����������",
	
	subway_stations = "Subway stations",
	subway_union_station = "Union station",
	subway_uptown = "Uptown",
	subway_chinatown = "Chinatown",
	subway_southport = "Southport",
	subway_west_side = "West Side",
	subway_sand_island = "Sand Island",
	subway_too_far = "�� ���������� ������� ������ �� �������!",
	
	admin_begin = "������������� ",
	admin_give = " ����� ��� ",
	you_give = "�� ������ ",
	and_ammo = " � ������� � ����.",
});