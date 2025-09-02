CREATE VIEW gold_funnel_conversion AS
SELECT
  c.CampaignId AS campaign_id,
  c.CampaignName AS campaign_name,
  c.CampaignDescription AS campaign_description,
  c.SubjectLine AS subject_line,
  c.Template AS template,
  c.Cost AS cost,
  e.EventType AS event_type,
  COUNT(e.EventId) AS event_count,
  CASE
    WHEN e.EventType = 'sent' THEN 1
    WHEN e.EventType = 'delivered' THEN 2
    WHEN e.EventType = 'html_open' THEN 3
    WHEN e.EventType = 'click' THEN 4
    WHEN e.EventType = 'optout_click' THEN 5
    WHEN e.EventType = 'spam' THEN 6
    ELSE 99 -- Catches any other event types
  END AS event_funnel_order
FROM
  silver_campaigns AS c
JOIN
  silver_events AS e
ON
  c.CampaignId = e.CampaignId
GROUP BY
  c.CampaignId,
  c.CampaignName,
  c.CampaignDescription,
  c.SubjectLine,
  c.Template,
  c.Cost,
  e.EventType
ORDER BY
  campaign_id,
  event_type;