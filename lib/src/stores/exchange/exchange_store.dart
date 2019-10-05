import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/src/domain/exchange/exchange_provider.dart';
import 'package:cake_wallet/src/domain/exchange/trade_request.dart';
import 'package:cake_wallet/src/domain/exchange/xmrto/xmrto_exchange_provider.dart';
import 'package:cake_wallet/src/domain/exchange/xmrto/xmrto_trade_request.dart';
import 'package:cake_wallet/src/domain/common/crypto_currency.dart';
import 'package:cake_wallet/src/domain/exchange/trade_history.dart';
import 'package:cake_wallet/src/stores/exchange/exchange_trade_state.dart';
import 'package:cake_wallet/src/stores/exchange/limits_state.dart';

part 'exchange_store.g.dart';

class ExchangeStore = ExchangeStoreBase with _$ExchangeStore;

abstract class ExchangeStoreBase with Store {
  @observable
  ExchangeProvider provider;

  @observable
  List<ExchangeProvider> providerList;

  @observable
  CryptoCurrency depositCurrency;

  @observable
  CryptoCurrency receiveCurrency;

  @observable
  LimitsState limitsState;

  @observable
  ExchangeTradeState tradeState;

  @observable
  String depositAmount;

  @observable
  String receiveAmount;

  TradeHistory tradeHistory;

  String depositAddress;

  String receiveAddress;

  ExchangeStoreBase(
      {@required ExchangeProvider initialProvider,
      @required CryptoCurrency initialDepositCurrency,
      @required CryptoCurrency initialReceiveCurrency,
      @required this.providerList,
      @required this.tradeHistory}) {
    provider = initialProvider;
    depositCurrency = initialDepositCurrency;
    receiveCurrency = initialReceiveCurrency;
    limitsState = LimitsInitialState();
    tradeState = ExchangeTradeStateInitial();
  }

  @action
  void changeProvider({ExchangeProvider provider}) {
    this.provider = provider;
  }

  @action
  void changeDepositCurrency({CryptoCurrency currency}) {
    depositCurrency = currency;
    _onPairChange();
  }

  @action
  void changeReceiveCurrency({CryptoCurrency currency}) {
    receiveCurrency = currency;
    _onPairChange();
  }

  @action
  void changeReceiveAmount({String amount}) {
    receiveAmount = amount;

    if (amount == null || amount.isEmpty) {
      depositAmount = '';
      return;
    }

    final _amount = double.parse(amount) ?? 0;
    
    provider
        .calculateAmount(
            from: depositCurrency, to: receiveCurrency, amount: _amount)
        .then((amount) => amount.toString())
        .then((amount) => depositAmount = amount);
  }

  @action
  void changeDepositAmount({String amount}) {
    depositAmount = amount;
    
    if (amount == null || amount.isEmpty) {
      depositAmount = '';
      return;
    }
    
    final _amount = double.parse(amount);
    provider
        .calculateAmount(
            from: depositCurrency, to: receiveCurrency, amount: _amount)
        .then((amount) => amount.toString())
        .then((amount) => receiveAmount = amount);
  }

  @action
  Future loadLimits() async {
    limitsState = LimitsIsLoading();

    try {
      final limits = await provider.fetchLimits(
          from: depositCurrency, to: receiveCurrency);
      limitsState = LimitsLoadedSuccessfully(limits: limits);
    } catch (e) {
      limitsState = LimitsLoadedFailure(error: e.toString());
    }
  }

  @action
  Future createTrade() async {
    TradeRequest request;

    if (provider is XMRTOExchangeProvider) {
      request = XMRTOTradeRequest(
          to: depositCurrency,
          from: receiveCurrency,
          amount: receiveAmount,
          address: receiveAddress,
          refundAddress: depositAddress);
    }

    try {
      tradeState = TradeIsCreating();
      final trade = await provider.createTrade(request: request);
      await tradeHistory.add(trade: trade);
      tradeState = TradeIsCreatedSuccessfully(trade: trade);
    } catch (e) {
      tradeState = TradeIsCreatedFailure(error: e.toString());
    }
  }

  void _onPairChange() {
    final isPairExist = provider.pairList
            .where((pair) =>
                pair.from == depositCurrency && pair.to == receiveCurrency)
            .length >
        0;

    if (!isPairExist) {
      final provider =
          _providerForPair(from: depositCurrency, to: receiveCurrency);

      if (provider != null) {
        this.provider = provider;
      }
    }

    loadLimits();
  }

  ExchangeProvider _providerForPair({CryptoCurrency from, CryptoCurrency to}) {
    final providers = providerList
        .where((provider) =>
            provider.pairList
                .where((pair) =>
                    pair.from == depositCurrency && pair.to == receiveCurrency)
                .length >
            0)
        .toList();

    return providers.length > 0 ? providers[0] : null;
  }
}
