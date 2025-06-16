public class AccountsSelector extends fflib_SObjectSelector  {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Account.ID,
            Account.Description,
            Account.Name,
            Account.AnnualRevenue };
    }
    public Schema.SObjectType getSObjectType() {
        return Account.sObjectType;
    }
    public List<Account> selectById(Set<ID> idSet){
        return (List<Account>) selectSObjectsById(idSet);
    }
}