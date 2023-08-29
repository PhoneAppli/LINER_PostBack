@isTest
private class LinerPostBackCallbackControllerTest {
    @IsTest(SeeAllData=true)
    static void UnitTest01() {
        //message Templateオブジェクトのカテゴリ選択リスト項目の選択リスト値を取得する
        Schema.DescribeFieldResult templateValue = anslut__Message_Template__c.anslut__Category__c.getDescribe();
        List<Schema.PicklistEntry> peList = TemplateValue.getPicklistValues();
        String value = peList.get(0).getValue();

        //message Templateの作成
        anslut__Message_Template__c amt = new anslut__Message_Template__c(
            Name = 'テストテンプレート',
            anslut__ChannelMessage__c = 'Line',
            anslut__Template_ID__c = 'TemplateId',
            anslut__Category__c = value
        );
        insert amt;

        //Postbackアクションを実行するLINEお友達のレコードを作成(送信先オブジェクトのレコード作成)
        Lead l = new Lead(
            LastName = 'テストリード',
            Company = 'テストカンパニー'
        );
        insert l;

        String getLead = l.Id;
        String getTemplateId = amt.anslut__Template_ID__c;
        //既に本番環境に作成をしているメタデータ型「Postback Action」のレコードを1件取得する
        List<anslut__Postback_Action__mdt> apaList = [SELECT MasterLabel, DeveloperName FROM anslut__Postback_Action__mdt WHERE DeveloperName = 'Test' LIMIT 1];
        String getPostbackId = apaList.get(0).DeveloperName;
        String getAction = apaList.get(0).MasterLabel;

        PageReference pageRef = Page.PostbackVFPage;

        //URLパラメータセット
        pageRef.getParameters().put('contactId', getLead);
        pageRef.getParameters().put('templateId', getTemplateId);
        pageRef.getParameters().put('postbackId', getPostbackId);
        pageRef.getParameters().put('action', getAction);
        Test.setCurrentPage(pageRef);
        Test.startTest();
            LinerPostBackCallbackController controller = new LinerPostBackCallbackController(); 
            controller.doPostbackAction();
        Test.stopTest();
    }
}