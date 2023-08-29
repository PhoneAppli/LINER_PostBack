public without sharing class LinerPostBackCallbackController extends anslut.LINER_CallbackMethod{
    public Map<String, String> params {get;set;}
    public LinerPostBackCallbackController() { //コンストラクタ
        params = ApexPages.currentPage().getParameters();
    }
    public PageReference doPostbackAction() {
        //パラメータ値取得
        process(params.get('contactId'), params.get('templateId'), params.get('postbackId'), params.get('action'));
        return null;
    }
    public PageReference process(String contactId, String templateId, String postbackId, String action) {
        //リードレコードの更新
        List<Lead> lList = [select id, Email, Company, HaishinKahi__c from Lead WHERE Id = :contactId];
        Lead l = lList[0];
        
        //どのPostbackアクションが起動したか判定
        if(action == 'Postback_Yes'){
            /* Postback_Yesというポストバックアクションが起動したときの処理 */
            l.HaishinKahi__c = TRUE;
        }
        else if(action == 'Postback_No'){
            /* Postback_Noというポストバックアクションが起動したときの処理 */
            l.HaishinKahi__c = FALSE;
        }
        //HaishinKahi__cは、LINEメッセージの配信の可否を示すチェックボックス型のカスタム項目
        update l;
        return null;
    }
}