import 'package:flutter/material.dart';
import 'vista_falla.dart'; // Asegúrate de tener esta vista en tu proyecto

class InicioChatGPT extends StatefulWidget {
  const InicioChatGPT({super.key});

  @override
  State<InicioChatGPT> createState() => _InicioChatGPTState();
}

class _InicioChatGPTState extends State<InicioChatGPT> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> _mensajes = [];
  String? _mensajeError;
  bool _isFocused = false;
  bool _chatIniciado = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_chatIniciado && _focusNode.hasFocus) {
        setState(() {
          _isFocused = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _enviarPregunta() async {
    final pregunta = _controller.text.trim();
    if (pregunta.isEmpty) return;

    setState(() {
      _mensajeError = null;
      _mensajes.add({'role': 'user', 'text': pregunta});
      _controller.clear();
      _chatIniciado = true;
    });

    _scrollHaciaAbajo();

    try {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _mensajes.add({'role': 'ai', 'text': 'Respuesta para: "$pregunta"'});
      });
      _scrollHaciaAbajo();
    } catch (e) {
      setState(() {
        _mensajeError = 'Error al obtener respuesta: $e';
      });
    }
  }

  void _scrollHaciaAbajo() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final inputHeight = 60.0;

    // 🔧 Barra de entrada ajustada para no quedar muy baja
    final double topPosition = (!_chatIniciado && !_isFocused)
        ? screenHeight / 2 - inputHeight / 2
        : screenHeight -
            inputHeight -
            MediaQuery.of(context).padding.bottom -
            60; // subimos la barra

    if (_mensajeError != null) {
      return VistaFalla(
        mensajeError: _mensajeError!,
        onRetry: () {
          setState(() {
            _mensajeError = null;
            _mensajes.clear();
            _controller.clear();
            _chatIniciado = false;
            _isFocused = false;
          });
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF343541),
      appBar: AppBar(
        backgroundColor: const Color(0xFF444654),
        elevation: 0,
        title: const Text('ChatGPT Demo'),
      ),
      body: Stack(
        children: [
          // Mensajes
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: inputHeight + 40,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _mensajes.isEmpty
                  ? const Center(
                      child: Text(
                        'Hola soy IA, pregunta',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _mensajes.length,
                      itemBuilder: (context, index) {
                        final mensaje = _mensajes[index];
                        final isUser = mensaje['role'] == 'user';

                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(16),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? const Color(0xFF19A37C)
                                  : const Color(0xFF444654),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isUser ? 16 : 0),
                                bottomRight: Radius.circular(isUser ? 0 : 16),
                              ),
                            ),
                            child: Text(
                              mensaje['text'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Barra de entrada
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: 16,
            right: 16,
            top: topPosition,
            child: Container(
              height: inputHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF444654),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        hintText: 'Haz una pregunta...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _enviarPregunta(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF19A37C)),
                    onPressed: _enviarPregunta,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
