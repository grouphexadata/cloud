const DESTINATION_EMAIL = 'fco.caballero83@gmail.com';
const ALLOWED_ORIGINS = [
  'https://TU-USUARIO.github.io',
  'https://TU-DOMINIO.com'
];

function doPost(e) {
  try {
    const requestBody = JSON.parse(e.postData.contents || '{}');
    const payload = requestBody.payload || {};
    const origin = (e && e.parameter && e.parameter.origin) || '';

    if (!requestBody.subject || !payload.email || !payload.need) {
      return jsonResponse({ ok: false, error: 'invalid_payload' }, 400);
    }

    const body = [
      'SOLICITUD DE INFORMACION | HEXADATA',
      '',
      'Fecha ISO: ' + (requestBody.submittedAt || new Date().toISOString()),
      'Origen detectado por frontend: ' + (requestBody.source || 'unknown'),
      'Origin HTTP/param: ' + (origin || 'not_provided'),
      '',
      'Nombre: ' + safeValue(payload.name),
      'Correo: ' + safeValue(payload.email),
      'Organizacion: ' + safeValue(payload.organization),
      'Solucion: ' + safeValue(payload.solution),
      'Prioridad: ' + safeValue(payload.priority),
      '',
      'Necesidad:',
      safeValue(payload.need),
      '',
      'Mensaje consolidado:',
      requestBody.message || ''
    ].join('\n');

    MailApp.sendEmail({
      to: DESTINATION_EMAIL,
      subject: requestBody.subject,
      body: body,
      replyTo: payload.email,
      name: 'HEXADATA Interest Gateway'
    });

    return jsonResponse({ ok: true }, 200);
  } catch (error) {
    return jsonResponse({ ok: false, error: String(error) }, 500);
  }
}

function doGet() {
  return jsonResponse({ ok: true, service: 'hexadata-interest-gateway' }, 200);
}

function safeValue(value) {
  return value ? String(value).trim() : 'No especificado';
}

function jsonResponse(data, statusCode) {
  const output = ContentService
    .createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);

  return output;
}

/*
DEPLOY
1. Abre https://script.google.com
2. Crea un nuevo proyecto y pega este archivo.
3. Deploy > New deployment > Web app.
4. Execute as: Me.
5. Who has access: Anyone.
6. Copia la URL /exec.
7. Pégala en deliveryConfig.endpointUrl dentro de hexadata_prompt.html.
8. Cambia endpointMode a 'endpoint-only' si quieres impedir cualquier fallback por mailto.

NOTAS
- Apps Script no ofrece control CORS fino como un backend tradicional. Para un sitio estático simple suele ser suficiente.
- Si quieres endurecerlo de verdad, migra este gateway a Cloud Run, Functions o tu propio backend con validación de origen, rate limiting y captcha.
*/
