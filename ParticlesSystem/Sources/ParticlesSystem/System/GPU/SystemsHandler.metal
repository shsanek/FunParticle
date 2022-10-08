

// clearAccelerations
// runRule
// applyAccelerations


#include <metal_stdlib>

struct ParticleModel {
    float mass;
    float2 position;
    float2 velocity;
};

struct ParticleSystemModel {
    float resistance;
    float4 color;
};

struct ParticleSystemRuleModel {
    float g;
    float maxDistanse;
};

kernel void clearAccelerations(
                               device float2 *accelerations [[ buffer(0) ]],
                               uint index [[thread_position_in_grid]]
                               )
{
    accelerations[index] = float2(0, 0);
}

kernel void runRule(
                    constant ParticleModel *particles [[ buffer(0) ]],
                    device float2 *accelerations [[ buffer(1) ]],
                    constant ParticleModel *target [[ buffer(2) ]],
                    constant ParticleSystemRuleModel *model [[ buffer(3) ]],
                    constant float *time [[ buffer(4) ]],
                    constant int *count [[ buffer(5) ]],
                    uint index [[thread_position_in_grid]]
                    )
{
    for (int i = 0; i < *count; i++) {
        float2 delta = particles[index].position - target[i].position;
        float distance = metal::length(delta);
        if (distance > 0 && distance < (*model).maxDistanse) {
            float f = (*model).g * (particles[index].mass * target[i].mass) / (distance);
            accelerations[index] += delta * (f * (*time));
        }
    }
}

kernel void applyAccelerations(
                               device ParticleModel *particles [[ buffer(0) ]],
                               constant float2 *accelerations [[ buffer(1) ]],
                               constant ParticleSystemModel *model [[ buffer(2) ]],
                               constant float *time [[ buffer(3) ]],
                               constant float2 *size [[ buffer(4) ]],
                               uint index [[thread_position_in_grid]]
                               )
{
    float2 velocity = particles[index].velocity + accelerations[index] * (*time);
    velocity -= (velocity * model->resistance * (*time));
    particles[index].velocity = velocity;
    particles[index].position += velocity;

    if (particles[index].position.x < 0) {
        particles[index].position.x = 0;
        particles[index].velocity.x = -particles[index].velocity.x;
    }
    if (particles[index].position.y < 0) {
        particles[index].position.y = 0;
        particles[index].velocity.y = -particles[index].velocity.y;
    }
    if (particles[index].position.x > size->x) {
        particles[index].position.x = size->x;
        particles[index].velocity.x = -particles[index].velocity.x;
    }
    if (particles[index].position.y > size->y) {
        particles[index].position.y = size->y;
        particles[index].velocity.y = -particles[index].velocity.y;
    }
}


struct RasterizerData
{
    float4 position [[position]];
    float pointsize [[point_size]];
};

vertex RasterizerData
particleVertexShader(
                     uint vertexID [[ vertex_id ]],
                     constant float2 *viewportSizePointer  [[ buffer(0) ]],
                     constant ParticleModel *particles [[ buffer(1) ]],
                     constant float *pointsize [[ buffer(2) ]]
                     )

{

    RasterizerData out;

    float2 pixelSpacePosition = particles[vertexID].position;

    float2 viewportSize = float2(*viewportSizePointer);

    out.position.xy = pixelSpacePosition / (viewportSize / 2.0) - float2(1, 1);
    out.position.z = 0.0;
    out.position.w = 1.0;
    out.pointsize = *pointsize;

    return out;
}

// Fragment function
fragment float4
particleFragmentShader(
                       RasterizerData  in           [[stage_in]],
                       constant ParticleSystemModel *model [[ buffer(0) ]]
                       )
{
    return model->color;
}
