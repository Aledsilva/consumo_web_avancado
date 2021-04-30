import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as agattp;

import 'Post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>>_recuperarDadosAPI() async {

    agattp.Response response = await agattp.get(_urlBase + "/posts");
    var dadosJson = json.decode(response.body);


    List<Post> novasPostagens = List();
    for(var post in dadosJson){

      print("posts " + post["title"]);
      Post p = Post(post["userId"],post["id"],post["title"],post["body"]);
      novasPostagens.add(p);
    }

    return novasPostagens;
  }


  _post() async {


    //metodo alternativo ( faz alterações na classe Post tb)
    //Post post = Post(120,null,"Tituliu", "Corpo da postagem");

    var corpo = json.encode(

      /*metodo alternativo : usar isso ao inves de usar o metodo abaixo,
      fica até mais dinamico*/
      //post.toJson()
        {
          "userId": 83,
          "id": null,
          "title": "Tituliu",
          "body": "Corpo da postagem"
        }
    );

    agattp.Response response = await agattp.post(
      _urlBase + "/posts",
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: corpo
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");

  }


  _put()async {

    var corpo = json.encode(
        {
          "userId": 83,
          "id": null,
          "title": null,
          "body": "Corpo da postagem"
        }
    );

    agattp.Response response = await agattp.put(
        _urlBase + "/posts/3",
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: corpo
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");

  }


  _patch()async {

    var corpo = json.encode(
        {
          "userId": 85,
          "body": "Wiiiii"
        }
    );

    agattp.Response response = await agattp.patch(
        _urlBase + "/posts/3",
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: corpo
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");

  }


  _delete() async {
    agattp.Response response = await agattp.delete(
      _urlBase + "/posts/5"
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo WEB Avançado"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                RaisedButton(
                  child: Text("Salvar"),
                  onPressed: _post,
                ),
                RaisedButton(
                  child: Text("Atualizar"),
                  onPressed: _patch,
                ),
                RaisedButton(
                  child: Text("Remover"),
                  onPressed: _delete,
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(

                future: _recuperarDadosAPI(),
                builder: (context, snapshot) {


                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if(snapshot.hasError){
                        print("lista: Erro ao carregar ");
                      }else{
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index){


                            //recuperar dados para exibir
                            List<Post> essaLista = snapshot.data;
                            Post post = essaLista[index];

                            return ListTile(
                              title: Text(post.title),
                              subtitle: Text(post.id.toString()),
                            );

                          },
                        );
                      }
                      break;
                  }
                },
              ),
            ),
            RaisedButton(child: Text("oi"),)//Future
          ],
        ),
      ),
    );
  }
}
