<?php

if (strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) != 'xmlhttprequest') {
	header('Location: '. (!empty($_SERVER['HTTP_REFERER']) ? $_SERVER['HTTP_REFERER'] : '/'));
}

$data = json_decode(file_get_contents("php://input"));

$errors = array();
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	if (empty($data->potential_customer->email))
		$errors["email"] = true;

	if (sizeof($errors) > 0)
		echo json_encode(array('status' => 'have_errors','errors' => $errors));
		
	$name = 'mgsn';
	$from = "no-reply@fant0m.pro";
	$email = "no-reply@fant0m.pro";
	$to = "roman.na@mail.ru, mb@msk.trinet.ru";

	$subject = $_SERVER["HTTP_HOST"] . " :: Сообщение из формы \"Оставить отзыв\"";		
	$body = "
			Информационное сообщение сайта " . $_SERVER["HTTP_HOST"] . "
			------------------------------------------------------------

			Вам было отправлено сообщение через форму \"Оставить отзыв\"

			Имя и фамилия: " . trim($data->potential_customer->name) . "
			Email: " . trim($data->potential_customer->email) . "
			Отзыв: " . trim($data->potential_customer->comment) . "
					
			------------------------------------------------------------
			Сообщение сгенерировано автоматически.
				";
	if (sendEmail($to, 'fant0m.pro', $from, $name, $email, $subject, $body)){
		echo json_encode(array('status' => 'success'));
		return;
	}

	echo json_encode(array('status' => 'have_errors'));
	return;
}	

function sendEmail(
		$To, // email получателя
		$nameFrom, // Имя отправителя
		$From, // email отправителя
		$nameReply, // Имя для ответа
		$Reply, // email для ответа
		$subject, // тема письма
		$body // текст письма
) {
	$headers = "From: =?UTF-8?B?".base64_encode($nameFrom)."?= <".$From.">\r\n";
	$headers .= "Reply-To: =?UTF-8?B?".base64_encode($nameReply)."?= <".$Reply.">\r\n";
	$headers .= "Bcc: fant0m@xaker.ru\r\n";
	$headers .= "Content-type: text/plain; charset=UTF-8\r\n";
	$headers .= "Mime-Version: 1.0\r\n";

	return mail($To, $subject, $body, $headers);
}		
