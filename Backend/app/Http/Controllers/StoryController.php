<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;

class StoryController extends Controller
{
    private $client;

    public function __construct()
    {
        $this->client = new Client();
    }

    public function generarHistoria(Request $request)
    {
        // Validar los parámetros de entrada
        $request->validate([
            'edad' => 'required|string',
            'ocupacion' => 'required|string',
            'idioma'=> 'required|string',
            'pais'=> 'required|string',
            'max_tokens' => 'nullable|integer|min:1|max:500', // Validación opcional para max_tokens
        ]);

        $edad = $request->input('edad');
        $ocupacion = $request->input('ocupacion');
        $idioma = $request->input('idioma');
        $pais = $request->input('pais');
        $maxTokens = $request->input('max_tokens', 100); // Valor por defecto de 100 si no se proporciona

        // Configura tu clave de API de Cohere
        $apiKey = env('COHERE_API_KEY');

        // Crea el prompt
        $prompt = "Genera una historia  corta impactante y que genera acción en idioma $idioma  sobre el cambio climático basado en el contexto de $pais para un usuario que es $ocupacion de $edad años. Utiliza datos y estadísticas del Centro de GEI de Estados Unidos para dar contexto a la narrativa. Deme directamente la historia";

        try {
            // Llama a la API de Cohere
            $response = $this->client->post('https://api.cohere.ai/generate', [
                'headers' => [
                    'Authorization' => 'Bearer ' . $apiKey,
                    'Content-Type' => 'application/json',
                ],
                'json' => [
                    'prompt' => $prompt,
                    'maxTokens' => $maxTokens, // Usar el valor proporcionado o el predeterminado
                    'temperature' => 0.7, // Ajusta según tus necesidades
                ],
            ]);

            // Decodifica la respuesta de la API
            $data = json_decode($response->getBody(), true);
            if (isset($data['text'])) {
                $historiaTexto = $data['text'];
            } else {
                return response()->json(['error' => 'No se pudo generar la historia.'], 500);
            }

            // Preguntas de seguimiento
            $preguntas = [
                "¿Qué piensas de la historia?",
                "¿Te gustaría que continuara?"
            ];

            return response()->json(['texto' => $historiaTexto, 'preguntas' => $preguntas]);
        } catch (RequestException $e) {
            // Manejo de errores específicos de la solicitud
            if ($e->getResponse()) {
                return response()->json(['error' => json_decode($e->getResponse()->getBody(), true)], $e->getResponse()->getStatusCode());
            }
            return response()->json(['error' => 'Error en la solicitud a la API: ' . $e->getMessage()], 500);
        } catch (\Exception $e) {
            // Manejo de otros errores
            return response()->json(['error' => 'Error inesperado: ' . $e->getMessage()], 500);
        }
    }
}
