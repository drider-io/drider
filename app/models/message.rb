class Message < ActiveRecord::Base
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'
  belongs_to :car_request

  scope :index, -> (user) {
    sql =<<SQL
SELECT MAX(id) as id FROM messages JOIN
  (
    SELECT DISTINCT from_id AS cor_id WHERE to_id = ?
    UNION ( SELECT DISTINCT to_id AS cor_id FROM messages WHERE from_id = ? )
  ) cors
ON
    from_id = ? AND to_id = cors.cor_id
  OR
    to_id = ? AND from_id = cors.cor_id
GROUP BY cors.cor_id
SQL
    Message.where("id IN (#{sanitize_sql_array([sql, user.id,user.id,user.id,user.id])})").order('id DESC')
}





def self.index1(user)
    sql =<<SQL
SELECT * from messages WHERE id in (
  SELECT MAX(id) as id FROM messages JOIN
    (
      SELECT DISTINCT from_id AS cor_id WHERE to_id = $1
      UNION ( SELECT DISTINCT to_id AS cor_id FROM messages WHERE from_id = $1 )
    ) cors
  ON
      from_id = $1 AND to_id = cors.cor_id
    OR
      to_id = $1 AND from_id = cors.cor_id
  GROUP BY cors.cor_id
)
SQL
Message.connection.exec_query(sql,'SQL', [[nil, user.id]])
end

#     lk=  <<SQL
#     id,
#     CASE
#      WHEN to_id = ? THEN from_id
#      WHEN from_id = ? THEN to_id
#     END as correspondent_id
#     SQL
#     conversations = Message.select(sanitize_sql_array((
#  , user.id))
#
# )

  #   correspondents = Message
  #                        .select('DISTINCT from_id AS cor_id')
  #                        .where(to: user)
  #                         .union(
  #                             Message
  #                                 .select('DISTINCT to_id AS cor_id')
  #                                 .where(from: user)
  #                         )
  #   cors = Message.arel_table.create_table_alias(correspondents, :cors)
  #
  #   msgs = Message.arel_table
  #   sql = msgs.project(msgs[:id].maximum, cors[:cor_id]).group(cors[:cor_id]).join(cors)
  #              .on((msgs[:to_id].eq(user.id).and(msgs[:from_id].eq(cors[:cor_id])))
  #                      .or(msgs[:from_id].eq(user.id).and(msgs[:to_id].eq(cors[:cor_id])))
  #              )
  #              .to_sql
  #   printf sql
  #   # ActiveRecord::Base.connection.execute(sql)
  #
  # }
  #
end
