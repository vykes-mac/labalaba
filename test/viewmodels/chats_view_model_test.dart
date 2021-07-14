import 'package:chat/chat.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:labalaba/data/datasources/datasource_contract.dart';
import 'package:labalaba/models/chat.dart';
import 'package:labalaba/viewmodels/chats_view_model.dart';
import 'package:mockito/mockito.dart';

class MockDatasource extends Mock implements IDatasource {}

class MockUserService extends Mock implements IUserService {}

void main() {
  ChatsViewModel sut;
  MockDatasource mockDatasource;
  MockUserService mockUserService;

  setUp(() {
    mockDatasource = MockDatasource();
    sut = ChatsViewModel(mockDatasource, mockUserService);
  });

  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2021-04-01"),
    'id': '4444'
  });

  test('initial chats return empty list', () async {
    when(mockDatasource.findAllChats()).thenAnswer((_) async => []);
    expect(await sut.getChats(), isEmpty);
  });

  test('returns list of chats', () async {
    final chat = Chat('123');
    when(mockDatasource.findAllChats()).thenAnswer((_) async => [chat]);
    final chats = await sut.getChats();
    expect(chats, isNotEmpty);
  });

  test('creates a new chat when receiving message for the first time',
      () async {
    when(mockDatasource.findChat(any)).thenAnswer((_) async => null);
    await sut.receivedMessage(message);
    verify(mockDatasource.addChat(any)).called(1);
  });

  test('add new message to existing chat', () async {
    final chat = Chat('123');

    when(mockDatasource.findChat(any)).thenAnswer((_) async => chat);
    await sut.receivedMessage(message);
    verifyNever(mockDatasource.addChat(any));
    verify(mockDatasource.addMessage(any)).called(1);
  });
}
