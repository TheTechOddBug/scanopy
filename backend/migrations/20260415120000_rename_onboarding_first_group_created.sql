-- Rename FirstGroupCreated to FirstDependencyCreated in onboarding JSONB arrays
UPDATE organizations SET onboarding = (
  SELECT jsonb_agg(
    CASE WHEN elem #>> '{}' = 'FirstGroupCreated'
    THEN '"FirstDependencyCreated"'::jsonb
    ELSE elem END
  )
  FROM jsonb_array_elements(onboarding) AS elem
) WHERE onboarding @> '["FirstGroupCreated"]';
