<?php
$date = $_GET["date"] ?? null;
$data = '';
switch ($date) {
    case '2025-07-27':
        $data = file_get_contents('api27.json');
        break;
    case '2025-07-28':
        $data = file_get_contents('api28.json');
        break;
    case '2025-07-29':
        $data = file_get_contents('api29.json');
        break;
    case '2025-07-30':
        $data = file_get_contents('api30.json');
        break;
    case '2025-07-31':
        $data = file_get_contents('api31.json');
        break;

    default:
        $data = '[]';
        break;
}
echo $data;
